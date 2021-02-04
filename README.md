# gembump
A simple Rubygems plugin for easy versioning.

## Install
You can install gembump by running the command

```
$ gem install gembump
```

You shouldn't need it for anything other than the command line, but if you do 
somehow see a reason, you probably know more than I do, and can figure it out 
for yourself.

## Usage
Once you install, you can use gembump by writing a command with the format

```
gem bump [<method>] <gemspec>
```

where method is the part of the version to bump, and `gemspec` is the name of 
the Rubygems specification file. You can omit the extension if it is ".gemspec".

If you omit the method, it will default to `patch`.

### Methods
You have 4 methods available to bump the version:
- `major` - increases the major version (1<sup>st</sup> number).
- `minor` - increases the minor version (2<sup>nd</sup> number).
- `patch` - increases the patch version (3<sup>rd</sup> number). Default if no 
method is supplied.
- `subpatch` - increase the subpatch version (4<sup>th</sup> number). This one 
isn't always used by or useful to everybody, and won't be included if it is 0.

Note that all of these methods increment their specified version number by 1, 
and resets the lower versions to 0. Higher versions won't be affected.

### Examples
#### `major`
``` bash
# version before: 1.2.3
gem bump major project-name.gemspec
# version after: 2.0.0
```
#### `minor`
```
# version before: 1.2.3
gem bump minor project-name.gemspec
# version after: 1.3.0
```
#### `patch`
```
# version before: 1.2.3
gem bump patch project-name.gemspec
# version after: 1.2.4
```
#### `subpatch`
```
# version before: 1.2.3
gem bump subpatch project-name.gemspec
# version after: 1.2.3.1

# version before: 1.2.3.1
gem bump patch project-name.gemspec
# version after: 1.2.4
```
#### No method given
```
# version before: 1.2.3
gem bump project-name.gemspec
# version after: 1.2.4
```
