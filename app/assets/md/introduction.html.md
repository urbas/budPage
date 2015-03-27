# Introduction

Bud is a build tool. You can define your C# projects with it and Bud will fetch your
projects' dependencies, build, run, test, package, and publish them for you. Bud
is highly customisable too. For example, you can define your own build- and release-cycle
tasks right in your build definition.

Bud is both a command line tool as well as a library. On the one hand, you can use it
to automate build tasks for your .NET projects. On the other hand, you can use it to
query information about projects and programmatically execute build-related tasks from
your .NET applications.

## Concepts

A build definition is a collection of key-value pairs. There are two types of keys: `ConfigKey` and
`TaskKey`. Every key has a path, such as `/project/Foo.Bar/main/cs/baseDir` or
`/build`. A value can be of any .NET type.

A value of a config key is evaluated when it is accessed for the first time. It is evaluated
once per lifetime of the build definition. A value of a task key is evaluated once per root-level task
invocation (i.e.: if a task calls another task twice, its value is evaluated once only and in the second
invocation the cached value is used).

You define values of config keys and task keys by building them up (i.e., you add small modifiers to a
`Settings` instance). For example, you can introduce your own key and value by calling
`settings.Add(MySettings.HelloWorldMessage.Init("Hello, World!"))`. The parameter to the
`Add` method is a modifier. This modifier initialises the
`HelloWorldMessage`
key with the value `"Hello, World!"` (if it has not been initialised before in `settings`).
You can define your own config and task keys like this:

```language-csharp
public static readonly ConfigKey<string> HelloWorldMessage = Key.Define("helloWorldMessage", "Prints a hello world message in the log.");

public static readonly TaskKey HelloWorld = Key.Define("helloWorld", "Prints a hello world message in the log.");
```

<div class="alert alert-info">
  <span class="label label-primary">Note:</span> The <code>Settings</code> class is immutable. Therefore,
  <code>settings.Add(...)</code> returns
  a new instance instead of mutating the existing one.
</div>