"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[72],{5284:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>d,contentTitle:()=>c,default:()=>f,frontMatter:()=>a,metadata:()=>l,toc:()=>u});var r=t(5893),s=t(1151),i=t(4214);const o="// ignore_for_file: avoid_print, unused_element\n\nimport 'dart:io';\nimport 'dart:typed_data';\n\nimport 'package:ribs_core/ribs_core.dart';\nimport 'package:ribs_effect/ribs_effect.dart';\n\nFuture<void> snippet1() async {\n  // file-example\n  final Resource<RandomAccessFile> fileResource = Resource.make(\n    IO.fromFutureF(() => File('/path/to/file.bin').open()),\n    (raf) => IO.exec(() => raf.close()),\n  );\n  // file-example\n\n  // file-example-use\n  // Use the resource by passing an IO op to the 'use' function\n  final IO<Uint8List> program =\n      fileResource.use((raf) => IO.fromFutureF(() => raf.read(100)));\n\n  (await program.unsafeRunFutureOutcome()).fold(\n    () => print('Program canceled.'),\n    (err) => print('Error: ${err.message}. But the file was still closed!'),\n    (bytes) => print('Read ${bytes.length} bytes from file.'),\n  );\n\n  // file-example-use\n}\n\nvoid snippet2() {\n  // multiple-resources\n  Resource<RandomAccessFile> openFile(String path) => Resource.make(\n        IO.fromFutureF(() => File(path).open()),\n        (raf) => IO.exec(() => raf.close()),\n      );\n\n  IO<Uint8List> readBytes(RandomAccessFile raf, int n) =>\n      IO.fromFutureF(() => raf.read(n));\n  IO<Unit> writeBytes(RandomAccessFile raf, Uint8List bytes) =>\n      IO.fromFutureF(() => raf.writeFrom(bytes)).voided();\n\n  Uint8List concatBytes(Uint8List a, Uint8List b) =>\n      Uint8List.fromList([a, b].expand((element) => element).toList());\n\n  /// Copy the first [n] bytes from [fromPathA] and [fromPathB], then write\n  /// bytes to [toPath]\n  IO<Unit> copyN(String fromPathA, String fromPathB, String toPath, int n) => (\n        openFile(fromPathA),\n        openFile(fromPathB),\n        openFile(toPath)\n      ).tupled().useN(\n        (fromA, fromB, to) {\n          return (readBytes(fromA, n), readBytes(fromB, n))\n              .parMapN(concatBytes)\n              .flatMap((a) => writeBytes(to, a));\n        },\n      );\n\n  copyN(\n    '/from/this/file',\n    '/and/this/file',\n    '/to/that/file',\n    100,\n  ).unsafeRunAndForget();\n  // multiple-resources\n}\n",a={sidebar_position:3},c="Resource",l={id:"effect/resource",title:"Resource",description:"Motivation",source:"@site/docs/effect/resource.mdx",sourceDirName:"effect",slug:"/effect/resource",permalink:"/ribs/docs/effect/resource",draft:!1,unlisted:!1,editUrl:"https://github.com/cranst0n/ribs/edit/main/website/docs/effect/resource.mdx",tags:[],version:"current",sidebarPosition:3,frontMatter:{sidebar_position:3},sidebar:"tutorialSidebar",previous:{title:"Retrying IO",permalink:"/ribs/docs/effect/io-retry"},next:{title:"Ref",permalink:"/ribs/docs/effect/ref"}},d={},u=[{value:"Motivation",id:"motivation",level:2},{value:"Use Case",id:"use-case",level:2},{value:"Combinators",id:"combinators",level:3}];function h(e){const n={admonition:"admonition",code:"code",h1:"h1",h2:"h2",h3:"h3",p:"p",strong:"strong",...(0,s.a)(),...e.components};return(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)(n.h1,{id:"resource",children:"Resource"}),"\n",(0,r.jsx)(n.h2,{id:"motivation",children:"Motivation"}),"\n",(0,r.jsx)(n.p,{children:"It's quite common to encounter a case where a developer will need to acquire\na limited resource (e.g. file, socket), use that resource in some way and then\nproperly release that resource. Failure to do so is an easy way to leak finite\nresources."}),"\n",(0,r.jsxs)(n.p,{children:[(0,r.jsx)(n.code,{children:"Resource"})," makes this common pattern easy to encode, without having to rely\non unwieldy and error prone ",(0,r.jsx)(n.code,{children:"try"}),"/",(0,r.jsx)(n.code,{children:"catch"}),"/",(0,r.jsx)(n.code,{children:"finally"})," blocks."]}),"\n",(0,r.jsx)(n.h2,{id:"use-case",children:"Use Case"}),"\n",(0,r.jsxs)(n.p,{children:["Here's a basic example of using ",(0,r.jsx)(n.code,{children:"Resource"})," in the wild in relation to reading\na ",(0,r.jsx)(n.code,{children:"File"}),":"]}),"\n",(0,r.jsx)(i.O,{language:"dart",snippet:o,section:"file-example"}),"\n",(0,r.jsxs)(n.p,{children:["We now have a ",(0,r.jsx)(n.code,{children:"Resource"})," that will automatically handle opening and closing the\nunderlying resource (i.e. the ",(0,r.jsx)(n.code,{children:"RandomAccessFile"}),") ",(0,r.jsx)(n.strong,{children:"regardless of whether the\noperation we use the resource with succeeds, fails or is canceled"}),". This\nnaturally begs the question of how we are supposed to use the resource. For\nthis example, let's say we need to read the first 100 bytes of data from the\nfile:"]}),"\n",(0,r.jsx)(i.O,{language:"dart",snippet:o,section:"file-example-use"}),"\n",(0,r.jsx)(n.h3,{id:"combinators",children:"Combinators"}),"\n",(0,r.jsx)(n.admonition,{type:"tip",children:(0,r.jsxs)(n.p,{children:[(0,r.jsx)(n.code,{children:"Resource"})," comes with many of the same combinators at ",(0,r.jsx)(n.code,{children:"IO"})," like ",(0,r.jsx)(n.code,{children:"map"}),",\n",(0,r.jsx)(n.code,{children:"flatMap"}),", etc."]})}),"\n",(0,r.jsxs)(n.p,{children:["Because ",(0,r.jsx)(n.code,{children:"Resource"})," comes with these combinators, composing and managing\nmultiple resources at one time become easy! When using ",(0,r.jsx)(n.code,{children:"try"}),"/",(0,r.jsx)(n.code,{children:"catch"}),"/",(0,r.jsx)(n.code,{children:"finally"}),",\nthings can get messy at best, and incorrect at worst. But using ",(0,r.jsx)(n.code,{children:"Resource"}),"\nit's possible to create readible, expressive code:"]}),"\n",(0,r.jsx)(i.O,{language:"dart",snippet:o,section:"multiple-resources"})]})}function f(e={}){const{wrapper:n}={...(0,s.a)(),...e.components};return n?(0,r.jsx)(n,{...e,children:(0,r.jsx)(h,{...e})}):h(e)}}}]);