# Guide


## Installation

### Windows

You can install Bud with [Chocolatey](https://chocolatey.org/packages/bud). Just use this command:

```language-bash
choco install bud
```

Verify that your installation succeeded by running <code>bud</code> in the command prompt.

### Linux

<div class="alert alert-warning">
  <span class="label label-warning">TODO:</span> Add support for Linux.
</div>

### OS X

<div class="alert alert-warning">
  <span class="label label-warning">TODO:</span> Add support for OS X.
</div>


## Creating a new project

Say the name of your project is `Foo`. Create the `Foo` directory, and place your C# sources into
`Foo/src/main/cs`.

<div class="panel panel-danger">
  <div class="panel-heading">
    <h3 class="panel-title">Important:</h3>
  </div>

  <div class="panel-body">
    You should give your project a unique name.
    Search for packages on <a href="https://www.nuget.org/packages/">NuGet</a> to ensure
    you're using a unique name.
  </div>
</div>

## Customising the build

To customise your builds, create the build configuration file `.bud/Build.cs`. If this
file does not exist, Bud will use a default build configuration. The following build
configuration is equivalent to the default one.

```language-csharp
using Bud;
using Bud.CSharp;
using Bud.Projects;
using System.IO;

public class Build : IBuild {
  public Settings Setup(Settings settings, string baseDir) {
    return settings.Project(Path.GetFileName(baseDir), baseDir, Cs.Exe(), Cs.Test());
  }
}
```

Call methods on the `settings` object to customise your build configuration.


## Building

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>build</code></pre>
  </div>
</div>

Run `bud build` in the `Foo` directory. This will produce the
executable for your project in `.bud/output/main/cs/debug/bin/Foo.exe`.

<div class="alert alert-info">
  <span class="label label-primary">Note:</span> Bud invokes the `build` task
  by default (if you run Bud without any command line arguments).
</div>


## Testing

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>test</code></pre>
  </div>
</div>


## Running executables

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
      <pre><code>run</code></pre>
  </div>
</div>


## Cleaning

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>clean</code></pre>
  </div>
</div>

Run `bud clean` to clean the files in the `.bud/output` folder.


## Generating solution and project files

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>generateSolution</code></pre>
  </div>
</div>

Run `bud generateSolution` to generate a Visual Studio solution for
your project. Bud will place the solution file `Foo.sln` into the root
directory of your project. Bud will also generate multiple csproj files in
`src/[scope]/cs` folders.

The following command will generate solution files for the build-level sources (i.e., to be able to edit the
`.bud/Build.cs` file in an IDE):

```language-bash
bud -b 1 generateSolution
```


## Publishing to NuGet

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>publish</code></pre>
  </div>
</div>

You have to create an account with [NuGet](https://www.nuget.org/) before you can publish your
project to the NuGet repository.

Once you have an account, get your API key from [here](https://www.nuget.org/account) and
place it into the `$HOME/.bud/nuGetApiKey` file.

Now you can run `bud publish`. This will push the package to
`https://www.nuget.org/packages/Foo/`.


## Setting the version of your project

This is how you specify the version of your project in the `.bud/Build.cs` file:

1. First add the `using Bud.Projects;` directive to the top of the file.

2. Then call `settings.Version("1.2.3")` in your `IBuild` class.

## Specifying dependencies

To add the `Newtonsoft.Json` library to your project
you must place `Cs.Dependency("Newtonsoft.Json")` into
the `.bud/Build.cs` like this:

```language-csharp
settings.Project("Foo.Bar", baseDir, Cs.Exe(Cs.Dependency("Newtonsoft.Json")), Cs.Test());
```


## Using a plugin

Plugins add new functionality to your build. For example, the
[HelloWorldPlugin](https://github.com/urbas/Bud.Examples.HelloWorldPlugin)
adds the `helloWorld` task to the build. This task prints a hello message when
you invoke `bud helloWorld`.

To use the plugin `Bud.Examples.HelloWorldPlugin` in your build do the following:

1. create the file `.bud/.bud/Build.cs` with the following contents:

    ```language-csharp
    using Bud;
    using Bud.CSharp;
    using Bud.Projects;
    
    public class Build : IBuild {
      public Settings Setup(Settings settings, string baseDir) {
        return settings.BuildDefinition(
          Cs.Dependency("Bud.Examples.HelloWorldPlugin")
        );
      }
    }
    ```
    
    This will make sure Bud downloads the plugin and makes it available to your
    build definition.

2. Edit the build definition in `.bud/Build.cs`:

    ```language-csharp
    using Bud;
    using Bud.Examples.HelloWorldPlugin;
    
    public class Build : IBuild {
      public Settings Setup(Settings settings, string baseDir) {
        return settings.Add(new HelloWorldPlugin());
      }
    }
    ```

3. Now you can invoke `bud helloWorld`.



## Writing a plugin

The build definition file `.bud/Build.cs` should look something like this:

```language-csharp
using Bud;
using Bud.Projects;

public class Build : IBuild {
  public Settings Setup(Settings settings, string baseDir) {
    return settings
      .Version("0.0.3")
      .BudPlugin("Bud.Examples.HelloWorldPlugin", baseDir);
  }
}
```

You'll have to publish your plugin before you'll be able to use it.

Please use the following plugins as a reference source:

1. [Hello world plugin](https://github.com/urbas/Bud.Examples.HelloWorldPlugin)

