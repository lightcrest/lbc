_OLD_PATH=$PATH

PATH=$LBCMDDIR:.

for cmd in help cd pushd popd dirs pwd ; do enable -n $cmd ; done

LBCMD="PATH=$_OLD_PATH $LBCMDDIR/lbc"

alias help="$LBCMD help"
alias status="$LBCMD status"
alias push="$LBCMD push"
alias init-host="$LBCMD init-host"
alias promote="$LBCMD promote"
alias reload="$LBCMD reload"
alias restart="$LBCMD restart"
alias git="PATH=$_OLD_PATH git"
alias commit="git commit -a"
alias add-host="$LBCMD add-host"
alias vi="PATH=$_OLD_PATH vi"
alias emacs="PATH=$_OLD_PATH emacs"
PS1="lbc> "
