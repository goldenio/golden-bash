# Golden Bash

**Golden Bash** is a tool kit to help you arrange plugins, aliases, auto-completions and themes for your own bash environment.

The barebone of golden-bash is borrowed from [bash-it](https://github.com/revans/bash-it) and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh). They are good forerunners but provide too much to match personal needs, especially for [chef](https://github.com/opscode/chef) and [puppet](https://github.com/puppetlabs/puppet).

## Install

```
cd ~
git clone http://github.com/goldenio/golden-bash.git ~/.golden_bash
cat <<EOF > ~/.bash_profile
export GOLDEN_BASH="\$HOME/.golden_bash"
export GOLDEN_BASH_THEME="bobby"
source \$GOLDEN_BASH/golden_bash.sh
EOF
```

Edit your `~/.bash_profile` file to customize golden-bash.

## Usage

Just create your plugins, aliases and completions to the available folder of their own directories and enable them.

```
touch plugins/available/my_first.plugin.bash
golden-bash enable plugin my_first
reload
```

## Themes

Put your theme in themes folder, change `GOLDEN_BASH_THEME` in your `~/.bash_profile` and `reload` to see the change.

## Help

Simply type `golden-bash` in bash-shell to show the help page.

```
golden-bash show plugins        # shows installed and available plugins
golden-bash show aliases        # shows installed and available aliases
golden-bash show completions    # shows installed and available completions

golden-bash help plugins        # shows help for installed plugins
golden-bash help aliases        # shows help for installed aliases
golden-bash help completions    # shows help for installed completions
```

## License

use MIT license.
