"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[555],{8421:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>u,contentTitle:()=>s,default:()=>f,frontMatter:()=>l,metadata:()=>p,toc:()=>d});var a=t(7462),i=(t(7294),t(3905)),o=t(4214);const r="// ignore_for_file: avoid_print, unused_local_variable, unused_element\n\nimport 'dart:io';\nimport 'dart:math';\n\nimport 'package:async/async.dart';\nimport 'package:ribs_core/ribs_core.dart';\n\nFuture<void> snippet1() async {\n  /// io-1\n\n  final rng = Future(() => Random.secure().nextInt(1000));\n\n  await rng.then((x) => rng.then((y) => print('x: $x / y: $y')));\n\n  /// io-1\n}\n\nFuture<void> snippet2() async {\n  /// io-2\n\n  // Substitute the definition of fut with it's expression\n  // x and y are different! (probably)\n  await Future(() => Random.secure().nextInt(1000)).then((x) =>\n      Future(() => Random.secure().nextInt(1000))\n          .then((y) => print('x: $x / y: $y')));\n\n  /// io-2\n}\n\nFuture<void> snippet3() async {\n  /// io-3\n\n  final rng = IO.delay(() => Random.secure().nextInt(1000));\n\n  // x and y are different! (probably)\n  await rng\n      .flatMap((x) => rng.flatMap((y) => IO.println('x: $x / y: $y')))\n      .unsafeRunToFuture();\n\n  /// io-3\n}\n\nFuture<void> asyncSnippet1() async {\n  /// io-async-1\n\n  IO<A> futureToIO<A>(Function0<Future<A>> fut) {\n    IO.async_<A>((cb) {\n      fut().then(\n        (a) => cb(Right(a)),\n        onError: (Object err, StackTrace st) => cb(Left(IOError(err, st))),\n      );\n    });\n\n    throw UnimplementedError();\n  }\n\n  /// io-async-1\n}\n\nFuture<void> errorHandlingSnippet1() async {\n  /// error-handling-1\n\n  // composable handler using handleError\n  final ioA = IO.delay(() => 90 / 0).handleError((ioError) => 0);\n  final ioB = IO\n      .delay(() => 90 / 0)\n      .handleErrorWith((ioError) => IO.pure(double.infinity));\n\n  IO<double> safeDiv(int a, int b) => IO.defer(() {\n        if (b != 0) {\n          return IO.pure(a / b);\n        } else {\n          return IO.raiseError(IOError('cannot divide by 0!'));\n        }\n      });\n\n  /// error-handling-1\n}\n\nvoid safeResourcesSnippet1() {\n  /// safe-resources-1\n  final sink = File('path/to/file').openWrite();\n\n  try {\n    // use sink...\n  } catch (e) {\n    // catch error\n  } finally {\n    sink.close();\n  }\n\n  /// safe-resources-1\n}\n\nvoid safeResourcesSnippet2() {\n  /// safe-resources-2\n\n  final sink = IO.delay(() => File('path/to/file')).map((f) => f.openWrite());\n\n  // bracket *ensures* that the sink is closed\n  final program = sink.bracket(\n    (sink) => IO.exec(() => sink.writeAll(['Hello', 'World'])),\n    (sink) => IO.exec(() => sink.close()),\n  );\n\n  /// safe-resources-2\n}\n\nFuture<void> conversionsSnippet() async {\n  /// conversions-1\n\n  IO.fromOption(const Some(42), () => Exception('raiseError: none'));\n\n  IO.fromEither(Either.right(42));\n\n  IO.fromFuture(IO.delay(() => Future(() => 42)));\n\n  IO.fromCancelableOperation(IO.delay(\n    () => CancelableOperation.fromFuture(\n      Future(() => 32),\n      onCancel: () => print('canceled!'),\n    ),\n  ));\n\n  /// conversions-1\n\n  /// conversions-bad-future\n\n  final fut = Future(() => print('bad'));\n\n  // Too late! Future is already running!\n  final ioBad = IO.fromFuture(IO.pure(fut));\n\n  // IO.pure parameter is not lazy so it's evaluated immediately!\n  final ioAlsoBad = IO.fromFuture(IO.pure(Future(() => print('also bad'))));\n\n  // Here we preserve laziness so that ioGood is referentially transparent\n  final ioGood = IO.fromFuture(IO.delay(() => Future(() => print('good'))));\n\n  /// conversions-bad-future\n}\n\nFuture<void> cancelationSnippet() async {\n  /// cancelation-1\n  int count = 0;\n\n  // Our IO program\n  final io = IO\n      .pure(42)\n      .delayBy(const Duration(seconds: 10))\n      .onCancel(IO.exec(() => count += 1))\n      .onCancel(IO.exec(() => count += 2))\n      .onCancel(IO.exec(() => count += 3));\n\n  // .start() kicks off the IO execution and gives us a handle to that\n  // execution in the form of an IOFiber\n  final fiber = await io.start().unsafeRunToFuture();\n\n  // We immediately cancel the IO\n  fiber.cancel().unsafeRunAndForget();\n\n  // .join() will wait for the fiber to finish\n  // In this case, that's immediate since we've canceled the IO above\n  final outcome = await fiber.join().unsafeRunToFuture();\n\n  // Show the Outcome of the IO as well as confirmation that our `onCancel`\n  // handlers have been called since the IO was canceled\n  print('Outcome: $outcome | count: $count'); // Outcome: Canceled | count: 6\n  /// cancelation-1\n}\n",l={sidebar_position:1},s="IO",p={unversionedId:"core/effect/io",id:"core/effect/io",title:"IO",description:"IO is one of the most useful types in Ribs because it enables us to control",source:"@site/docs/core/effect/io.mdx",sourceDirName:"core/effect",slug:"/core/effect/io",permalink:"/ribs/docs/core/effect/io",draft:!1,editUrl:"https://github.com/cranst0n/ribs/edit/main/website/docs/core/effect/io.mdx",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1},sidebar:"tutorialSidebar",previous:{title:"Collections",permalink:"/ribs/docs/core/collections"},next:{title:"Resource",permalink:"/ribs/docs/core/effect/resource"}},u={},d=[{value:"Motivation",id:"motivation",level:2},{value:"Asynchronous Execution",id:"asynchronous-execution",level:2},{value:"IO.pure",id:"iopure",level:3},{value:"IO.delay",id:"iodelay",level:3},{value:"IO.async",id:"ioasync",level:3},{value:"Error Handling",id:"error-handling",level:2},{value:"Safe Resource Handling",id:"safe-resource-handling",level:2},{value:"Conversions",id:"conversions",level:2},{value:"Cancelation",id:"cancelation",level:2},{value:"&#39;Unsafe&#39; Operations",id:"unsafe-operations",level:2}],c={toc:d},m="wrapper";function f(e){let{components:n,...t}=e;return(0,i.kt)(m,(0,a.Z)({},c,t,{components:n,mdxType:"MDXLayout"}),(0,i.kt)("h1",{id:"io"},"IO"),(0,i.kt)("p",null,(0,i.kt)("inlineCode",{parentName:"p"},"IO")," is one of the most useful types in Ribs because it enables us to control\nside effects and make it easier to write purely functional programs."),(0,i.kt)("admonition",{type:"info"},(0,i.kt)("p",{parentName:"admonition"},"If you're familiar with the ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," type from ",(0,i.kt)("a",{parentName:"p",href:"https://typelevel.org/cats-effect/"},"Cats Effect"),",\nthen Ribs ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," should look very similar. In fact, Ribs ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," is a very close\nport from Scala to Dart! The API is designed to stay as close as possible to\nthe original implementation.")),(0,i.kt)("p",null,"IO"),(0,i.kt)("h2",{id:"motivation"},"Motivation"),(0,i.kt)("p",null,"While Darts ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," type has it's uses, it also suffers from issues that make\nit unsuitable for functional programming. Consider the following code:"),(0,i.kt)(o.O,{language:"dart",snippet:r,section:"io-1",mdxType:"CodeSnippet"}),(0,i.kt)("p",null,"If you run this code, you should notice that the value of ",(0,i.kt)("inlineCode",{parentName:"p"},"x")," and ",(0,i.kt)("inlineCode",{parentName:"p"},"y")," are\nalways the same! Can you see why this is problematic? Now consider this piece\nof code where we replace each reference to ",(0,i.kt)("inlineCode",{parentName:"p"},"fut")," with the expression that ",(0,i.kt)("inlineCode",{parentName:"p"},"fut"),"\nevaluated to:"),(0,i.kt)(o.O,{language:"dart",snippet:r,section:"io-2",mdxType:"CodeSnippet"}),(0,i.kt)("p",null,"When we do the substitution, the meaning of the program changes which leads us\nto the conclusion that ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," is not referentially transparent! That means\nthat it's insufficient for use in pure functions."),(0,i.kt)("p",null,"Here is where ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," steps in. It provides lazy, pure capabilities that provide\ngreater control over execution and dealing with failure. Here's the same\nprogram from above, using ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," instead of ",(0,i.kt)("inlineCode",{parentName:"p"},"Future"),"."),(0,i.kt)(o.O,{language:"dart",snippet:r,section:"io-3",mdxType:"CodeSnippet"}),(0,i.kt)("p",null,"You'll notice there are some differences in the APIs between ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," and ",(0,i.kt)("inlineCode",{parentName:"p"},"IO"),"\nbut for the sake of this example, you can assume that ",(0,i.kt)("inlineCode",{parentName:"p"},"flatMap")," is equivalent\nto ",(0,i.kt)("inlineCode",{parentName:"p"},"then")," and ",(0,i.kt)("inlineCode",{parentName:"p"},"IO.println")," is equivalent to ",(0,i.kt)("inlineCode",{parentName:"p"},"print"),". If you squint hard enough,\nthis ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," version should look pretty similar to the original implementation\nwhere we defined ",(0,i.kt)("inlineCode",{parentName:"p"},"rng")," using ",(0,i.kt)("inlineCode",{parentName:"p"},"Future"),". ",(0,i.kt)("strong",{parentName:"p"},(0,i.kt)("em",{parentName:"strong"},"However")),", this piece of code is\npure and referentially transparent because of the way ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," is implemented!"),(0,i.kt)("p",null,"Along with this small but important quality, ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," provides the following\nfeatures:"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Asynchronous Execution"),(0,i.kt)("li",{parentName:"ul"},"Error Handling"),(0,i.kt)("li",{parentName:"ul"},"Safe Resource Handling"),(0,i.kt)("li",{parentName:"ul"},"Cancelation")),(0,i.kt)("h2",{id:"asynchronous-execution"},"Asynchronous Execution"),(0,i.kt)("p",null,(0,i.kt)("inlineCode",{parentName:"p"},"IO")," is able to describe both synchronous and asynchronous effects."),(0,i.kt)("h3",{id:"iopure"},"IO.pure"),(0,i.kt)("p",null,(0,i.kt)("inlineCode",{parentName:"p"},"IO.pure")," accepts a value. This means that there is no laziness or delaying\nof effects. Any parameter is eagerly evaluated."),(0,i.kt)("h3",{id:"iodelay"},"IO.delay"),(0,i.kt)("p",null,(0,i.kt)("inlineCode",{parentName:"p"},"IO.delay")," can be used for ",(0,i.kt)("strong",{parentName:"p"},"synchronous")," effects that can be evaluated\nimmediately once the ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," itself is evaluated (within the context of the\nIO run loop)."),(0,i.kt)("h3",{id:"ioasync"},"IO.async"),(0,i.kt)("p",null,(0,i.kt)("inlineCode",{parentName:"p"},"IO.async")," and ",(0,i.kt)("inlineCode",{parentName:"p"},"IO.async_")," is used to describe ",(0,i.kt)("strong",{parentName:"p"},"asynchronous")," effects that require a\ncallback to be invoked to indicate completion and resume execution. Using ",(0,i.kt)("inlineCode",{parentName:"p"},"async"),", we\ncan write a function that will convert a ",(0,i.kt)("strong",{parentName:"p"},"lazy")," ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," into an ",(0,i.kt)("inlineCode",{parentName:"p"},"IO"),"."),(0,i.kt)(o.O,{language:"dart",title:"IO.async_",snippet:r,section:"io-async-1",mdxType:"CodeSnippet"}),(0,i.kt)("admonition",{type:"info"},(0,i.kt)("p",{parentName:"admonition"},(0,i.kt)("inlineCode",{parentName:"p"},"IO")," already has this conversion for ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," included but the example\nillustrates one case where ",(0,i.kt)("inlineCode",{parentName:"p"},"IO.async_")," is useful.")),(0,i.kt)("p",null,"The only difference between ",(0,i.kt)("inlineCode",{parentName:"p"},"IO.async")," and ",(0,i.kt)("inlineCode",{parentName:"p"},"IO.async_")," is that with ",(0,i.kt)("inlineCode",{parentName:"p"},"IO.async"),"\nyou can include a cancelation finalizer. Since ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," doesn't have a\nmechanism for cancelation (at least at the time of this writing), we can safely\nuse ",(0,i.kt)("inlineCode",{parentName:"p"},"IO.async_"),"."),(0,i.kt)("admonition",{type:"tip"},(0,i.kt)("p",{parentName:"admonition"},"To see an example of using ",(0,i.kt)("inlineCode",{parentName:"p"},"IO.async"),", check out the implementation of ",(0,i.kt)("inlineCode",{parentName:"p"},"IO.fromCancelableOperation"),".")),(0,i.kt)("h2",{id:"error-handling"},"Error Handling"),(0,i.kt)("p",null,"One of the first recommendations on the ",(0,i.kt)("a",{parentName:"p",href:"https://dart.dev/language/error-handling"},"Dart Error Handling page"),"\ndemonstrates using ",(0,i.kt)("inlineCode",{parentName:"p"},"Exception"),"s paired with ",(0,i.kt)("inlineCode",{parentName:"p"},"try"),"/",(0,i.kt)("inlineCode",{parentName:"p"},"catch"),"/",(0,i.kt)("inlineCode",{parentName:"p"},"finally")," to manage\nerrors in your programs. But it's alredy been established that throwing\nexceptions is a side-effect! This rules out using them in our pure FP programs."),(0,i.kt)("p",null,"That begs the question on how we create and handle errors using ",(0,i.kt)("inlineCode",{parentName:"p"},"IO"),"."),(0,i.kt)(o.O,{language:"dart",title:"Error Handling with IO",snippet:r,section:"error-handling-1",mdxType:"CodeSnippet"}),(0,i.kt)("h2",{id:"safe-resource-handling"},"Safe Resource Handling"),(0,i.kt)("p",null,"Let's begin with a fairly typical resource pattern used in Dart program that\nwant's opens a file, writes some data and then wants to make sure the file\nresource is closed:"),(0,i.kt)(o.O,{language:"dart",title:"Resource Safety try/catch/finally",snippet:r,section:"safe-resources-1",mdxType:"CodeSnippet"}),(0,i.kt)("p",null,"Now let's write an equivalent program using ",(0,i.kt)("inlineCode",{parentName:"p"},"IO"),":"),(0,i.kt)(o.O,{language:"dart",title:"Resource Safety with IO",snippet:r,section:"safe-resources-2",mdxType:"CodeSnippet"}),(0,i.kt)("p",null,"This version using ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," has all the resource safety guarentees of the ",(0,i.kt)("inlineCode",{parentName:"p"},"try"),"/",(0,i.kt)("inlineCode",{parentName:"p"},"catch")," version but\ndoesn't use ",(0,i.kt)("inlineCode",{parentName:"p"},"Exception"),"s to avoid side-effects."),(0,i.kt)("h2",{id:"conversions"},"Conversions"),(0,i.kt)("p",null,(0,i.kt)("inlineCode",{parentName:"p"},"IO")," comes with a few helper functions to convert common FP types into an ",(0,i.kt)("inlineCode",{parentName:"p"},"IO"),"."),(0,i.kt)(o.O,{language:"dart",title:"IO Conversions",snippet:r,section:"conversions-1",mdxType:"CodeSnippet"}),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("p",{parentName:"li"},(0,i.kt)("strong",{parentName:"p"},"IO.fromOption"),": Takes an ",(0,i.kt)("inlineCode",{parentName:"p"},"Option")," and will either return a pure\nsynchronous ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," in the case of ",(0,i.kt)("inlineCode",{parentName:"p"},"Some")," or raise an error in the case of ",(0,i.kt)("inlineCode",{parentName:"p"},"None"))),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("p",{parentName:"li"},(0,i.kt)("strong",{parentName:"p"},"IO.fromEither"),": Returns a pure ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," if the ",(0,i.kt)("inlineCode",{parentName:"p"},"Either")," is ",(0,i.kt)("inlineCode",{parentName:"p"},"Right")," or if\n",(0,i.kt)("inlineCode",{parentName:"p"},"Left"),", will raise an error using the value of the ",(0,i.kt)("inlineCode",{parentName:"p"},"Left"),".")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("p",{parentName:"li"},(0,i.kt)("strong",{parentName:"p"},"IO.fromFuture"),": Since ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," is eagerly evaluated and memoized,\n",(0,i.kt)("inlineCode",{parentName:"p"},"fromFuture")," takes a parameter of type ",(0,i.kt)("inlineCode",{parentName:"p"},"IO<Future>")," to control the laziness\nand ensure referential transparency."))),(0,i.kt)("admonition",{type:"caution"},(0,i.kt)("p",{parentName:"admonition"},"Simply using ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," doesn't magically make the ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," parameter referentially transparent!\nYou must still take care on controlling the evaluation of the ",(0,i.kt)("inlineCode",{parentName:"p"},"Future"),".")),(0,i.kt)(o.O,{language:"dart",title:"IO.fromFuture",snippet:r,section:"conversions-bad-future",mdxType:"CodeSnippet"}),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("strong",{parentName:"li"},"IO.fromCancelableOperation"),": This behaves in the same way as\n",(0,i.kt)("inlineCode",{parentName:"li"},"IO.fromFuture")," but is able to take advantage of some of the advanced features\nof ",(0,i.kt)("inlineCode",{parentName:"li"},"CancelableOperation"),".")),(0,i.kt)("h2",{id:"cancelation"},"Cancelation"),(0,i.kt)("p",null,(0,i.kt)("inlineCode",{parentName:"p"},"IO")," also allows you to build cancelable operations."),(0,i.kt)(o.O,{language:"dart",title:"IO Cancel Example",snippet:r,section:"cancelation-1",mdxType:"CodeSnippet"}),(0,i.kt)("p",null,"This is obviously a contrived example but exhibits that you have a great deal\nof power controlling the execution of an ",(0,i.kt)("inlineCode",{parentName:"p"},"IO"),"."),(0,i.kt)("p",null,"Also note that an ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," can only be checked for cancelation at it's asynchronous\nboundaries. Types of asynchronous boundaries include:"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"IO.sleep")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"IO.cede")," (or autoCede occurances)"),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("inlineCode",{parentName:"li"},"IO.async"))),(0,i.kt)("h2",{id:"unsafe-operations"},"'Unsafe' Operations"),(0,i.kt)("p",null,"There are a few functions on ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," prefixed with the word ",(0,i.kt)("inlineCode",{parentName:"p"},"unsafe"),". These are\nwhat you should be calling at the 'edge(s)' of your program. In a completely\npure program, you should only call an 'unsafe' function once, in the main\nmethod after you've built and described your program using IO."),(0,i.kt)("p",null,"The reason these functions include the 'unsafe' keyword isn't because your\ncomputer will explode when they're called. They're unsafe because they are\nnot pure functions and will interpret your ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," and perform side effects.\n'Unsafe' is included because you should always take care before deciding\nto call these functions."),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("p",{parentName:"li"},(0,i.kt)("strong",{parentName:"p"},"unsafeRunAsync"),": As the name indicates, this will evaluate the ",(0,i.kt)("inlineCode",{parentName:"p"},"IO"),"\nasynchronously, and the provided callback will be executed when it has\nfinished;")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("p",{parentName:"li"},(0,i.kt)("strong",{parentName:"p"},"unsafeRunAndForget"),": Same as ",(0,i.kt)("inlineCode",{parentName:"p"},"unsafeRunAsync")," but no callback is provided.")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("p",{parentName:"li"},(0,i.kt)("strong",{parentName:"p"},"unsafeRunToFuture"),": Evaluates the ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," and returns a ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," that will\ncomplete with the value of the ",(0,i.kt)("inlineCode",{parentName:"p"},"IO")," or any error that is encountered during\nthe evaluation.")),(0,i.kt)("li",{parentName:"ul"},(0,i.kt)("p",{parentName:"li"},(0,i.kt)("strong",{parentName:"p"},"unsafeRunToFutureOutcome"),": Returns a ",(0,i.kt)("inlineCode",{parentName:"p"},"Future")," that will complete with\nthe ",(0,i.kt)("inlineCode",{parentName:"p"},"Outcome")," of the ",(0,i.kt)("inlineCode",{parentName:"p"},"IO"),", being one of 3 possible states:"),(0,i.kt)("ul",{parentName:"li"},(0,i.kt)("li",{parentName:"ul"},"The value itself (successful)"),(0,i.kt)("li",{parentName:"ul"},"The error encountered (errored)"),(0,i.kt)("li",{parentName:"ul"},"Marker indicating the ",(0,i.kt)("inlineCode",{parentName:"li"},"IO")," was canceled before completing (canceled)")))))}f.isMDXComponent=!0}}]);