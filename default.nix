{ config, getopt, git, writeShellScriptBin, revision } :

  name: branch:

    writeShellScriptBin
      name
      ''
      set -euo pipefail
      shopt -s shift_verbose

      PATCH=
      NIXPKGS_GIT=

      NAME="''${0##*/}"

      usage()
      {
        echo "Usage: $NAME -n <Nixpkgs git repository> [-p]" >&2
        exit 1
      }


      if ! ARGUMENTS=$(${getopt}/bin/getopt --quiet --options 'n:p' -n "$NAME" -- "$@")
      then
        usage
      fi

      eval set -- "$ARGUMENTS"
      unset ARGUMENTS

      while true; do
        case "$1" in
          ('-n')
            NIXPKGS_GIT="$2"
            shift 2
            continue
          ;;

          ('-p')
            PATCH="-p"
            shift
            continue
          ;;

          ('--')
            shift
            break
          ;;

          (*)
            echo 'Internal error!' >&2
            exit 2
          ;;
        esac
      done

      # No extra arguments accepted
      #
      if [[ $# -gt 0 ]]
      then
        usage
      fi

      # Check that NIXPKGS_GIT is set and it is a directory and has a
      # .git sub directory and hope for the best... :-)
      #
      if [[  ! ( $NIXPKGS_GIT  &&  -d $NIXPKGS_GIT  &&  -d $NIXPKGS_GIT/.git )  ]]
      then
        usage
      fi


      ${git}/bin/git -C "$NIXPKGS_GIT" log $PATCH ${revision}..$(${git}/bin/git -C "$NIXPKGS_GIT" rev-parse --symbolic-full-name "${branch}@{upstream}")
      ''
