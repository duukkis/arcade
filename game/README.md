# Arcade game #

Readme...

## Requirement ##

1. Install dotnet core (3.1 works for me) <https://dotnet.microsoft.com/download>
2. Install required mono packages (or just all eg: mono-complete and monodevelop)
3. Install MonoGame <http://www.monogame.net/downloads/>

If you want to install monogame templates for dotnet cli use `dotnet new --install MonoGame.Templates.CSharp` to install the c# template.

## Release build ##

Run `dotnet publish -c Release -r <architecture>` where architecture can be eg `linux-x64` or for raspberry pi `linux-arm` (https://docs.microsoft.com/en-us/dotnet/core/rid-catalog)
