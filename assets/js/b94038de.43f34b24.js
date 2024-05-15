"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[274],{3186:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>d,contentTitle:()=>l,default:()=>h,frontMatter:()=>a,metadata:()=>c,toc:()=>y});var i=n(5893),r=n(1151),o=n(4214);const s="// ignore_for_file: unused_local_variable\n\nimport 'dart:convert';\nimport 'dart:io';\n\nimport 'package:ribs_core/ribs_core.dart';\nimport 'package:ribs_effect/ribs_effect.dart';\nimport 'package:ribs_json/ribs_json.dart';\n\n// flaky-op\nIO<Json> flakyOp() => IO.pure(HttpClient()).bracket(\n      (client) => IO\n          .fromFutureF(() =>\n              client.getUrl(Uri.parse('http://api.flaky.org/account/123')))\n          .flatMap((req) => IO.fromFutureF(() => req.close()))\n          .flatMap((resp) => IO.fromFutureF(() => utf8.decodeStream(resp)))\n          .flatMap((bodyText) => IO.fromEither(Json.parse(bodyText))),\n      (client) => IO.exec(() => client.close()),\n    );\n// flaky-op\n\nvoid retrySimple() {\n  // retry-simple\n  final IO<Json> retry3Times = flakyOp().retrying(RetryPolicy.limitRetries(3));\n  // retry-simple\n\n  // custom-retrying\n  final IO<Json> customRetry = flakyOp().retrying(\n    RetryPolicy.constantDelay(5.seconds),\n    wasSuccessful: (json) => json.isObject,\n    isWorthRetrying: (error) => error.message.toString().contains('oops'),\n    onError: (error, details) => IO.println('Attempt ${details.retriesSoFar}.'),\n    onFailure: (json, details) => IO.println('$json failed [$details]'),\n  );\n  // custom-retrying\n}\n\nvoid customPolicies() {\n  // custom-policy-1\n  // Exponential backoff with a maximum delay or 20 seconds\n  flakyOp().retrying(\n    RetryPolicy.exponentialBackoff(1.second).capDelay(20.seconds),\n  );\n\n  // Jitter backoff that will stop any retries after 1 minute\n  flakyOp().retrying(\n    RetryPolicy.fullJitter(2.seconds).giveUpAfterCumulativeDelay(1.minute),\n  );\n\n  // Retry every 2 seconds, giving up after 10 seconds, but then retry\n  // an additional 5 times\n  flakyOp().retrying(RetryPolicy.constantDelay(2.seconds)\n      .giveUpAfterCumulativeDelay(10.seconds)\n      .followedBy(RetryPolicy.limitRetries(5)));\n  // custom-policy-1\n\n  // custom-policy-2\n  // Join 2 policies, where retry is stopped when *either* policy wants to\n  // and the maximum delay is chosen between the two policies\n  flakyOp().retrying(\n    RetryPolicy.exponentialBackoff(1.second)\n        .giveUpAfterDelay(10.seconds)\n        .join(RetryPolicy.limitRetries(10)),\n  );\n\n  // Meet results in a policy that will retry until *both* policies want to\n  // give up and the minimum delay is chosen between the two policies\n  flakyOp().retrying(\n    RetryPolicy.exponentialBackoff(1.second)\n        .giveUpAfterDelay(10.seconds)\n        .meet(RetryPolicy.limitRetries(10)),\n  );\n  // custom-policy-2\n}\n",a={sidebar_position:2},l="Retrying IO",c={id:"effect/io-retry",title:"Retrying IO",description:"It's very common to encounter calculations in the wild that can fail for any",source:"@site/docs/effect/io-retry.mdx",sourceDirName:"effect",slug:"/effect/io-retry",permalink:"/ribs/docs/effect/io-retry",draft:!1,unlisted:!1,editUrl:"https://github.com/cranst0n/ribs/edit/main/website/docs/effect/io-retry.mdx",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"tutorialSidebar",previous:{title:"IO",permalink:"/ribs/docs/effect/io"},next:{title:"Resource",permalink:"/ribs/docs/effect/resource"}},d={},y=[{value:"Flaky Operations",id:"flaky-operations",level:3},{value:"Declarative Retries",id:"declarative-retries",level:3},{value:"Retrying Customization",id:"retrying-customization",level:3},{value:"Retry Policy Customization",id:"retry-policy-customization",level:3}];function u(e){const t={admonition:"admonition",code:"code",em:"em",h1:"h1",h3:"h3",li:"li",p:"p",strong:"strong",ul:"ul",...(0,r.a)(),...e.components};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(t.h1,{id:"retrying-io",children:"Retrying IO"}),"\n",(0,i.jsx)(t.p,{children:"It's very common to encounter calculations in the wild that can fail for any\nnumber or reasons. When making an HTTP call, for example, the operation could\nfail due to:"}),"\n",(0,i.jsxs)(t.ul,{children:["\n",(0,i.jsx)(t.li,{children:"Server is down"}),"\n",(0,i.jsx)(t.li,{children:"Client timeout exceeded"}),"\n",(0,i.jsx)(t.li,{children:"Request gave incorrect data"}),"\n",(0,i.jsx)(t.li,{children:"Returned data has missing/unexpected JSON fields"}),"\n",(0,i.jsx)(t.li,{children:"A cable being unplugged"}),"\n"]}),"\n",(0,i.jsxs)(t.p,{children:["This is only a few of the countless ways in which things can go sideways. Any\ntime you're interacting with the world outside your program such as a network\nor file system, failure ",(0,i.jsx)(t.em,{children:"is"})," an option. In certains circumstance, like in an\nHTTP request as described above, it may be worthwhile to retry the operation\nand hope that things go better the next time. Because this situation is so\ncommon, Ribs provides a retry mechanism for ",(0,i.jsx)(t.code,{children:"IO"})," out of the box!"]}),"\n",(0,i.jsx)(t.h3,{id:"flaky-operations",children:"Flaky Operations"}),"\n",(0,i.jsx)(t.p,{children:"Let's define our flaky operation so that we can see how Ribs allows us to\neasily bake in retry capabilities:"}),"\n",(0,i.jsx)(o.O,{language:"dart",snippet:s,section:"flaky-op"}),"\n",(0,i.jsx)(t.p,{children:"It's not very important that you immediately understand every single bit of\nwhat this code does, so long as you understand that it makes an HTTP request\nto our fake endpoint and attempts to parse the response as a JSON string,\nusing the Ribs JSON library."}),"\n",(0,i.jsx)(t.h3,{id:"declarative-retries",children:"Declarative Retries"}),"\n",(0,i.jsxs)(t.p,{children:["Now that our flaky operation is defined let's apply the simplest ",(0,i.jsx)(t.code,{children:"RetryPolicy"}),"\nto it that we can:"]}),"\n",(0,i.jsx)(o.O,{language:"dart",snippet:s,section:"retry-simple"}),"\n",(0,i.jsxs)(t.p,{children:["And just like that, we've enhanced our original ",(0,i.jsx)(t.code,{children:"IO"})," to create a new ",(0,i.jsx)(t.code,{children:"IO"})," that\nwill automatically retry the operation if it fails, up to 3 more times.\nRecognize that this capability is available on ",(0,i.jsx)(t.em,{children:(0,i.jsx)(t.strong,{children:"any"})})," ",(0,i.jsx)(t.code,{children:"IO<A>"})," type so it's\ncompletely generic in terms of what the underlying operation is doing!"]}),"\n",(0,i.jsx)(t.h3,{id:"retrying-customization",children:"Retrying Customization"}),"\n",(0,i.jsxs)(t.p,{children:["The ",(0,i.jsx)(t.code,{children:"IO.retrying"})," function provides additional ways to customize the retry\nbehavior of your operation. Here's an example:"]}),"\n",(0,i.jsx)(o.O,{language:"dart",snippet:s,section:"custom-retry"}),"\n",(0,i.jsx)(t.p,{children:"Let's look at each argument to see what's available to you:"}),"\n",(0,i.jsxs)(t.ul,{children:["\n",(0,i.jsxs)(t.li,{children:[(0,i.jsx)(t.strong,{children:"policy"}),": In this example, ",(0,i.jsx)(t.code,{children:"RetryPolicy.contantDelay"})," is given, which will\ncontinually retry a failed operation after a specified delay."]}),"\n",(0,i.jsxs)(t.li,{children:[(0,i.jsx)(t.strong,{children:"wasSuccessful"}),": Logic you can provide to inspect a successful compuation\nand force another retry attempt."]}),"\n",(0,i.jsxs)(t.li,{children:[(0,i.jsx)(t.strong,{children:"isWorthRetrying"}),": Logic you can provide to inspect the ",(0,i.jsx)(t.code,{children:"RuntimeException"}),"\nand determine if the opration should be retried again, overriding the policy."]}),"\n",(0,i.jsxs)(t.li,{children:[(0,i.jsx)(t.strong,{children:"onError"}),": A side effect that is run every time the underlying ",(0,i.jsx)(t.code,{children:"IO"}),"\nencounters an error. In this case, the cumulative number or retries is\nprinted to stdout."]}),"\n",(0,i.jsxs)(t.li,{children:[(0,i.jsx)(t.strong,{children:"onFailure"}),": A side effect that is run every time the result from the\nunderlying ",(0,i.jsx)(t.code,{children:"IO"})," fails the ",(0,i.jsx)(t.code,{children:"wasSuccessful"})," predicate."]}),"\n"]}),"\n",(0,i.jsx)(t.h3,{id:"retry-policy-customization",children:"Retry Policy Customization"}),"\n",(0,i.jsx)(t.p,{children:"You can also customize your retry policy to achieve the exact behavior you\nwant by using combinators and/or combining any number of policies in a few\ndifferent ways. To start off look at these examples:"}),"\n",(0,i.jsx)(o.O,{language:"dart",title:"Modifying Retry Policies",snippet:s,section:"custom-policy-1"}),"\n",(0,i.jsx)(o.O,{language:"dart",title:"Composing Retry Policies",snippet:s,section:"custom-policy-2"}),"\n",(0,i.jsx)(t.admonition,{type:"tip",children:(0,i.jsxs)(t.p,{children:["There's virtually no limit to what you can do with ",(0,i.jsx)(t.code,{children:"RetryPolicy"})," but to get a\nfull handle of what's possible, you should check out the API documentation."]})})]})}function h(e={}){const{wrapper:t}={...(0,r.a)(),...e.components};return t?(0,i.jsx)(t,{...e,children:(0,i.jsx)(u,{...e})}):u(e)}}}]);