# Node Version Manager
# Implemented as a bash function
# To use source this file from your bash profile
#
# Implemented by Tim Caswell <tim@creationix.com>
# with much bash help from Matthew Ranney

# Auto detect the NVM_DIR

function command_exists
  if [ (count $argv) -eq 1 ]
    if which $argv[1] >/dev/null ^&1
      return 0
    end
  end
  return 1
end

function true
  return 0
end

if not test -d "$NVM_DIR"
  set NVM_DIR (dirname $argv[1])
end

# function for running native executable
# https://github.com/fish-shell/fish-shell/issues/154
function call --description 'Run a builtin or program' --no-scope-shadowing
  set -l redir
  switch "$argv[1]";
      case -r --redirection
      set redir $argv[2]
      set -e argv[1 2]
  end
  set -l cmd $argv[1]
  set -e argv[1]

  # 
  # Set job control for interactive mode
  #
  set -l __call_recover_mode
  if status --is-interactive-job-control
      set __call_recover_mode interactive
  else
      if status --is-full-job-control
          set __call_recover_mode full
      else
          set __call_recover_mode none
      end
  end
  if status --is-interactive
      status --job-control full
  end

  #
  # Define main function and call
  #
  echo "function -S __run_internal_function_name; $cmd \$argv $redir; end"  | .
  set -e cmd
  set -e redir
  __run_internal_function_name $argv

  #
  # Clear and return
  #
  set -l stat $status
  functions -e __run_internal_function_name
  status --job-control $__call_recover_mode
  return $stat
end

# Expand a version using the version cache
function nvm_version
  set -l PATTERN $argv[1]
  # The default version is the current one
  if test -z "$PATTERN"
    set PATTERN 'current'
  end

  set VERSION (nvm_ls $PATTERN | tail -n1)
  echo $VERSION

  if [ "$VERSION" = 'N/A' ]
    return
  end
end

function nvm_remote_version
  set -l PATTERN $argv[1]
  set VERSION (nvm_ls_remote $PATTERN | tail -n1)
  echo $VERSION

  if [ "$VERSION" = 'N/A' ]
    return
  end
end



function nvm_ls
  set -l PATTERN $argv[1]
  set -l VERSIONS ''
  if [ "$PATTERN" = 'current' ]
    if command_exists node
      echo (node -v 2>/dev/null)
    end
    return
  end
  if test -f "$NVM_DIR/alias/$PATTERN"
    nvm_version (cat $NVM_DIR/alias/$PATTERN)
    return
  end
  # If it looks like an explicit version, don't do anything funny
  switch $PATTERN
    case 'v?*.?*.?*'
      set VERSIONS $PATTERN
    case '*'
      set -l current_dir (pwd)
      set VERSIONS (cd $NVM_DIR; 
        and \ls -d v$PATTERN* 2>/dev/null | sort -t. -k 1.2,1n -k 2,2n -k 3,3n )
      cd $current_dir
  end
  if test -z "$VERSIONS"
    echo "N/A"
    return
  end
  echo $VERSIONS
  return
end

function nvm_ls_remote
  set -l PATTERN $argv[1]
  if test -n "$PATTERN"
    set -l corrected (echo $PATTERN | grep -v '^v')
    if test -n "$corrected"
      set PATTERN "v$PATTERN"
    end
  else
    set PATTERN ".*"
  end
  set -l VERSIONS (curl -s http://nodejs.org/dist/ | egrep -o 'v[0-9]+\.[0-9]+\.[0-9]+' | grep -w $PATTERN | sort -t. -u -k 1.2,1n -k 2,2n -k 3,3n)
  if test -z "$VERSIONS"
    echo "N/A"
    return
  end
  echo $VERSIONS
  return
end

function nvm_checksum
  if [ $argv[1] = $argv[2] ]
    return
  else
    echo 'Checksums do not match.'
    return 1
  end
end

function print_versions
  set -l OUTPUT ''
  set -l PADDED_VERSION ''
  for VERSION in $argv[1]
    set PADDED_VERSION (printf '%10s' $VERSION)
    if test -d "$NVM_DIR/$VERSION"
      set PADDED_VERSION "$PADDED_VERSION"
    end
    set OUTPUT "$OUTPUT"\n"$PADDED_VERSION"
  end
  echo -e "$OUTPUT" | column
end

function nvm
  if [ (count $argv) -lt 1 ]
    nvm help
    return
  end

  # Try to figure out the os and arch for binary fetching
  set -l uname (uname -a)
  set -l os ''
  set -l arch (uname -m)
  switch $uname
    case 'Linux*'
      set os 'linux' 
    case 'Darwin*'
      set os 'darwin' 
    case 'SunOS*'
      set os 'sunos'
  end
  switch $uname
    case '*x86_64*'
      set arch 'x64'
    case '*i*86*'
      set arch 'x86'
  end

  # initialize local variables
  set -l VERSION ''
  set -l ADDITIONAL_PARAMETERS ''

  switch $argv[1]
    case "help"
      echo
      echo "Node Version Manager"
      echo
      echo "Usage:"
      echo "    nvm help                    Show this message"
      echo "    nvm install <version>       Download and install a <version>"
      echo "    nvm uninstall <version>     Uninstall a version"
      echo "    nvm use <version>           Modify PATH to use <version>"
      echo "    nvm run <version> [<args>]  Run <version> with <args> as arguments"
      echo "    nvm ls                      List installed versions"
      echo "    nvm ls <version>            List versions matching a given description"
      echo "    nvm ls-remote               List remote versions available for install"
      echo "    nvm deactivate              Undo effects of NVM on current shell"
      echo "    nvm alias [<pattern>]       Show all aliases beginning with <pattern>"
      echo "    nvm alias <name> <version>  Set an alias named <name> pointing to <version>"
      echo "    nvm unalias <name>          Deletes the alias named <name>"
      echo "    nvm copy-packages <version> Install global NPM packages contained in <version> to current version"
      echo
      echo "Example:"
      echo "    nvm install v0.4.12         Install a specific version number"
      echo "    nvm use 0.2                 Use the latest available 0.2.x release"
      echo "    nvm run 0.4.12 myApp.js     Run myApp.js using node v0.4.12"
      echo "    nvm alias default 0.4       Auto use the latest installed v0.4.x version"
      echo
    case "install"
      # initialize local variables
      set -l binavail 0
      set -l t ''
      set -l url ''
      set -l sum ''
      set -l tarball ''

      if not command_exists curl
        echo 'NVM Needs curl to proceed.' >&2
      end

      if [ (count $argv) -lt 2 ]
        nvm help
        return
      end
      set VERSION (nvm_remote_version $argv[2])
      set ADDITIONAL_PARAMETERS ''
      set -e argv[1]
      set -e argv[1]
      while [ (count $argv) -ne 0 ]
        set ADDITIONAL_PARAMETERS "$ADDITIONAL_PARAMETERS $argv[1]"
        set -e argv[1]
      end
      test -d "$NVM_DIR/$VERSION"; and echo "$VERSION is already installed."; and return

      # shortcut - try the binary if possible.
      if test -n "$os"
        # binaries started with node 0.8.6
        if test -z (echo "$VERSION" | sed -r 's/v0\.(8\.[012345]|[1234567]\.[0-9]+)//g')
          set binavail 0
        else            
          set binavail 1
        end
        if [ $binavail -eq 1 ]
          set t "$VERSION-$os-$arch"
          
          set url "http://nodejs.org/dist/$VERSION/node-$t.tar.gz"
          set sum (curl -s http://nodejs.org/dist/$VERSION/SHASUMS.txt.asc | grep node-$t.tar.gz | awk '{print $1}')
          set -l current_dir (pwd)
          if test -n (mkdir -p "$NVM_DIR/bin/node-$t"
              and cd "$NVM_DIR/bin"
              and curl -C - --progress-bar $url -o "node-$t.tar.gz"
              and nvm_checksum (shasum node-$t.tar.gz | awk '{print $1}') $sum
              and tar -xzf "node-$t.tar.gz" -C "node-$t" --strip-components 1
              and mv "node-$t" "../$VERSION"; and rm -f "node-$t.tar.gz")
            nvm use $VERSION
          else
            echo "Binary download failed, trying source." >&2
            cd "$NVM_DIR/bin"; and rm -rf "node-$t.tar.gz" "node-$t"
          end
          cd $current_dir
          return
        end
      end

      echo "Additional options while compiling: $ADDITIONAL_PARAMETERS"

      set tarball ''
      set sum ''
      if test -n (curl -Is "http://nodejs.org/dist/$VERSION/node-$VERSION.tar.gz" | grep '200 OK')
        set tarball "http://nodejs.org/dist/$VERSION/node-$VERSION.tar.gz"
        set sum (curl -s http://nodejs.org/dist/$VERSION/SHASUMS.txt | grep node-$VERSION.tar.gz | awk '{print $1}')
      else if test -n (curl -Is "http://nodejs.org/dist/node-$VERSION.tar.gz" | grep '200 OK')
        set tarball "http://nodejs.org/dist/node-$VERSION.tar.gz"
      end
      # use python2 for Archlinux
      if test -n (expr match (uname -a) '\(.*ARCH.*\)')
        not test -d $NVM_DIR/bin; and mkdir $NVM_DIR/bin
        ln -s /usr/bin/python2 $NVM_DIR/bin/python 2>/dev/null
        set -x PATH $NVM_DIR/bin $PATH
      end
      if test -n "$tarball"
        mkdir -p "$NVM_DIR/src"
        and cd "$NVM_DIR/src"
        and curl --progress-bar $tarball -o "node-$VERSION.tar.gz"
        and nvm_checksum (shasum node-$VERSION.tar.gz | awk '{print $1}') $sum
        and tar -xzf "node-$VERSION.tar.gz"
        and cd "node-$VERSION"
        and ./configure --prefix="$NVM_DIR/$VERSION" $ADDITIONAL_PARAMETERS
        and make
        and rm -f "$NVM_DIR/$VERSION" 2>/dev/null
        and make install
        if [ $status = 0 ]
          nvm use $VERSION
          if not command_exists npm
            echo "Installing npm..."
            if test -n (expr match $VERSION '\(^v0\.\(1\.[0-9]\{1,2\}\|2\.[012]\)\)')
              echo "npm requires node v0.2.3 or higher"
            else
              set clean yes
              set npm_install 0.2.19
              curl https://npmjs.org/install.sh | sh
            end
          end
        else
          echo "nvm: install $VERSION failed!"
        end
      end
      if test -n (expr match (uname -a) '\(.*ARCH.*\)')
        test -n $NVM_DIR; and rm -r $NVM_DIR/bin
        set -x PATH (echo $PATH | sed -r "s/[^ ]$NVM_DIR\/bin //g")
      end
    case "uninstall"
      [ (count $argv) -ne 2 ]; and nvm help; and return
      if [ $argv[2] = (nvm_version) ]
        echo "nvm: Cannot uninstall currently-active node version, $argv[2]."
        return
      end
      set VERSION (nvm_version $argv[2])
      if not test -d "$NVM_DIR/$VERSION"
        echo "$VERSION version is not installed yet... installing"
        nvm install $VERSION
        return
      end

      set t "$VERSION-$os-$arch"

      # Delete all files related to target version.
      mkdir -p "$NVM_DIR/src"
      and cd "$NVM_DIR/src"
      and rm -rf "node-$VERSION" 2>/dev/null
      and rm -f "node-$VERSION.tar.gz" 2>/dev/null
      and mkdir -p "$NVM_DIR/bin"
      and cd "$NVM_DIR/bin"
      and rm -rf "node-$t" 2>/dev/null
      and rm -f "node-$t.tar.gz" 2>/dev/null
      and rm -rf "$NVM_DIR/$VERSION" 2>/dev/null
      echo "Uninstalled node $VERSION"

      # Rm any aliases that point to uninstalled version.
      for A in (grep -l $VERSION $NVM_DIR/alias/*)
        nvm unalias (basename $A)
      end
    case "deactivate"
      set -l path_index 0
      for path in $PATH
        set path_index (math $path_index + 1)
        if test -n (expr match (echo $path) "\($NVM_DIR/.*/bin\)")
          set -e PATH[$path_index]
          functions -e nvm_version nvm_remote_version nvm_ls nvm_ls_remote nvm_checksum print_versions nvm
          echo "$NVM_DIR/*/bin removed from "\$"PATH"
          set path_clean true
        end
      end
      if test -z "$path_clean"
        echo "Could not find $NVM_DIR/*/bin in \$PATH"
      end

      set -l manpath_index 0
      for manpath in $MANPATH
        set manpath_index (math $manpath_index + 1)
        if test -n (expr match (echo $manpath) "\($NVM_DIR/.*/share/man\)")
          set -e MANPATH[$manpath_index]
          echo "$NVM_DIR/*/share/man removed from \$MANPATH"
          set manpath_clean true
        end
      end
      if test -z "$manpath_clean"
        echo "Could not find $NVM_DIR/*/share/man in \$MANPATH"
      end

    case "use"
      if [ (count $argv) -ne 2 ]
        nvm help
        return
      end
      set VERSION (nvm_version $argv[2])
      if not test -d "$NVM_DIR/$VERSION"
        echo "$VERSION version is not installed yet"
        return
      end

      set -l path_index 0
      for path in $PATH
        set path_index (math $path_index + 1)
        if test -n (expr match (echo $path) "\($NVM_DIR/.*/bin\)")
          set -e PATH[$path_index]
        end
      end
      set -x PATH $NVM_DIR/$VERSION/bin $PATH

      set -l manpath_index 0
      for manpath in $MANPATH
        set manpath_index (math $manpath_index + 1)
        if test -n (expr match (echo $manpath) "\($NVM_DIR/.*/share/man\)")
          set -e MANPATH[$manpath_index]
        end
      end
      set -x MANPATH $NVM_DIR/$VERSION/share/man $MANPATH

      set -x NVM_PATH "$NVM_DIR/$VERSION/lib/node"
      set -x NVM_BIN "$NVM_DIR/$VERSION/bin"
      echo "Now using node $VERSION"
    case "run"
      # run given version of node
      if [ (count $argv) -lt 2 ]
        nvm help
        return
      end
      set VERSION (nvm_version $argv[2])
      if not test -d "$NVM_DIR/$VERSION"
        echo "$VERSION version is not installed yet"
        return
      end
      echo "Running node $VERSION"
      if [ (count $argv) -eq 3 ]
        set node_argv $argv[3]
      else
        set node_argv ''
      end
      set node_exec "$NVM_DIR/$VERSION/bin/node $node_argv"
      call $node_exec
    case "ls"
      if [ (count $argv) -eq 1 ]
        set argv[2] ""
        print_versions (nvm_ls $argv[2])
        set -e argv[2]
      else
        print_versions (nvm_ls $argv[2])
      end
      if [ (count $argv) -eq 1 ]
        echo -n "current: "\t; and nvm_version current
        nvm alias
      end
      return 0
    case "ls-remote"
      if [ (count $argv) -lt 2 ]
        set argv[2] ''
      end
      print_versions (nvm_ls_remote $argv[2])
      return
    case "alias"
      mkdir -p $NVM_DIR/alias
      if [ (count $argv) -le 2 ]
        set -l current_dir (pwd)
        if [ (count $argv) -lt 2 ]
          set argv[2] ''
        end
        cd $NVM_DIR/alias
        and for ALIAS in (\ls "$argv[2]"* 2>/dev/null)
          set DEST (cat $ALIAS)
          set VERSION (nvm_version $DEST)
          if [ "$DEST" = "$VERSION" ]
            echo "$ALIAS -> $DEST"
          else
            echo "$ALIAS -> $DEST (-> $VERSION)"
          end
        end
        cd $current_dir
        return
      end
      if test -z "$argv[3]"
        rm -f $NVM_DIR/alias/$argv[2]
        echo "$argv[2] -> *poof*"
        return
      end
      set VERSION (nvm_version $argv[3])
      if [ "$VERSION" = 'N/A' ]
        echo "! WARNING: Version '$argv[3]' does not exist." >&2
      end
      echo "$argv[3]" > "$NVM_DIR/alias/$argv[2]"
      if [ "$argv[3]" != "$VERSION" ]
        echo "$argv[2] -> $argv[3] (-> $VERSION)"
      else
        echo "$argv[2] -> $argv[3]"
      end
    case "unalias"
      mkdir -p $NVM_DIR/alias
      [ (count $argv) -ne 2 ]; and nvm help; and return
      not test -f "$NVM_DIR/alias/$argv[2]"; and echo "Alias $argv[2] doesn't exist!"; and return
      rm -f $NVM_DIR/alias/$argv[2]
      echo "Deleted alias $argv[2]"
    case "copy-packages"
      if [ (count $argv) -ne 2 ]
        nvm help
        return
      end
      set VERSION (nvm_version $argv[2])
      set ROOT (nvm use $VERSION; and npm -g root)
      set INSTALLS (nvm use $VERSION > /dev/null; and npm -g -p ll | grep $ROOT'\/[^/]\+$' | cut -d '/' -f 8 | cut -d ":" -f 2 | grep -v npm | tr "\n" " ")
      npm install -g $INSTALLS
    case "clear-cache"
      rm -f $NVM_DIR/v* 2>/dev/null
      echo "Cache cleared."
    case "version"
      if [ (count $argv) -ne 2 ]
        set argv[2] ''
      end 
      print_versions (nvm_version $argv[2])
    case '*'
      nvm help
  end
end

nvm ls default >/dev/null ^&1
and nvm use default >/dev/null
or true
