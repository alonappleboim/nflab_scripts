# nflab_scripts

This is a (versioned) repository of all our shared scripts. Big projects (e.g. operating system for robot, or image analysis platform) should be managed in a dedicated repository.

The repository is indexed by the scripting language, and then by sub directories as required, e.g.: “utils”, “vis”(ualization), etc.

If you wanna use a new language, just add a language folder (e.g. “Julia”) under the project root.

Scripts in this repository can assume that the project (and subdirs) are in the search path of the language interpreter. That means that you should configure your interpreter to include the path of your local clone and subdirs.

If you want to load specific data or code in these scripts, do so from a path that is found in nflab_scripts/<language>/config.<extension>. These config files are not versioned in this repository, and each clone can configure its own variables and values in them. For example, lab metadata, which is found in the lab gdrive will probably be needed, so the drive local path should be in this configuration file.