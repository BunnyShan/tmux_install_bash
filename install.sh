# Exit on error #
set -e

# Clean up #
rm -rf ~/tools/programs/libevent
rm -rf ~/tools/programs/ncurses
rm -rf ~/tools/programs/tmux

# Variable version #
TMUX_VERSION=2.2

# Create our directories #
mkdir -p ~/tools/test
mkdir -p ~/tools/programs/libevent
mkdir -p ~/tools/programs/ncurses
mkdir -p ~/tools/programs/tmux

############
# libevent #
############
cd ~/tools/test
wget https://github.com/downloads/libevent/libevent/libevent-2.0.19-stable.tar.gz
tar xvzf libevent-2.0.19-stable.tar.gz
cd libevent-*/
./configure --prefix=$HOME/tools/programs/libevent --disable-shared
make
make install

############
# ncurses  #
############
cd ~/tools/test
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz
tar xvzf ncurses-5.9.tar.gz
cd ncurses-5.9
./configure --prefix=$HOME/tools/programs/ncurses LDFLAGS="-static"
make
make install

############
# tmux     #
############
cd ~/tools/test
wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}

# open configure and find the line that says:
# PKG_CONFIG="pkg-config --static"
# And comment it out:
# #PKG_CONFIG="pkg-config --static"

# Build #
./configure --prefix=$HOME/tools/programs/tmux --enable-static CFLAGS="-I$HOME/tools/programs/libevent/include -I$HOME/tools/programs/ncurses/include/ncurses -I$HOME/tools/programs/ncurses/include/" LDFLAGS="-static -L$HOME/tools/programs/libevent/lib -L$HOME/tools/programs/libevent/include -L$HOME/tools/programs/ncurses/lib -L$HOME/tools/programs/ncurses/include/ncurses" PKG_CONFIG=/bin/false
CPPFLAGS="-I$HOME/tools/programs/libevent/include -I$HOME/tools/programs/ncurses/include/ncurses" LDFLAGS="-static -L$HOME/tools/programs/libevent/lib -L$HOME/tools/programs/libevent/include -L$HOME/tools/programs/ncurses/lib -L$HOME/tools/programs/ncurses/include/ncurses" make

# Move #
cp tmux ~/bin/tmux
