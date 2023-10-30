"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[480],{1124:(e,n,i)=>{i.r(n),i.d(n,{assets:()=>d,contentTitle:()=>c,default:()=>m,frontMatter:()=>a,metadata:()=>r,toc:()=>h});var t=i(5893),l=i(1151),s=i(4214);const o="import 'package:ribs_core/ribs_core.dart';\n\n// ilist\n\nfinal l = IList.range(0, 10);\nfinal plusOne = l.map((n) => n + 1);\nfinal odds = l.filter((n) => n.isOdd);\n\nfinal maybeFirstElement = l.headOption;\nfinal numLessThan5 = l.count((n) => n < 5);\nfinal combined = l.concat(l);\nfinal dropLast3 = l.dropRight(3);\n\nfinal anyBigNumbers = l.exists((a) => a > 100);\nfinal everyoneLessThan1000 = l.forall((a) => a < 1000);\n\nfinal maybe4 = l.find((a) => a == 4);\n\n// ilist\n\n// nel\n\nfinal nonEmptyList = nel(1, [2, 3, 4, 5]);\n\nfinal first = nonEmptyList.head;\nfinal nelOdds = nonEmptyList.filter((a) => a.isOdd);\n\n// nel\n\n// imap\n\nfinal map = IMap.fromIterable([\n  ('red', 1),\n  ('orange', 2),\n  ('yellow', 3),\n  ('green', 4),\n  ('blue', 5),\n  ('indigo', 6),\n  ('violet', 7),\n]);\n\nfinal updatedMap = map.updated('green', 90);\nfinal defaultValue = map.withDefaultValue(-1);\nfinal defaultValue2 = map.withDefault((key) => key.length);\n\n// imap\n\n// iset\n\nfinal iset = ISet.of([1, 3, 5, 7, 9]);\n\nfinal remove5 = iset.excl(5);\nfinal remove1and9 = iset.removedAll([1, 9]);\nfinal add11 = iset + 11;\n\n// iset\n",a={sidebar_position:5},c="Collections",r={id:"core/collections",title:"Collections",description:"Ribs had it's own IList collection implementation but it was eventually",source:"@site/docs/core/collections.mdx",sourceDirName:"core",slug:"/core/collections",permalink:"/ribs/docs/core/collections",draft:!1,unlisted:!1,editUrl:"https://github.com/cranst0n/ribs/edit/main/website/docs/core/collections.mdx",tags:[],version:"current",sidebarPosition:5,frontMatter:{sidebar_position:5},sidebar:"tutorialSidebar",previous:{title:"Validated",permalink:"/ribs/docs/core/validated"},next:{title:"IO",permalink:"/ribs/docs/core/effect/io"}},d={},h=[{value:"IList",id:"ilist",level:2},{value:"NonEmptyIList",id:"nonemptyilist",level:2},{value:"IMap",id:"imap",level:2},{value:"ISet",id:"iset",level:2}];function p(e){const n=Object.assign({h1:"h1",admonition:"admonition",p:"p",code:"code",strong:"strong",em:"em",h2:"h2"},(0,l.ah)(),e.components);return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(n.h1,{id:"collections",children:"Collections"}),"\n",(0,t.jsxs)(n.admonition,{type:"info",children:[(0,t.jsxs)(n.p,{children:["Ribs had it's own ",(0,t.jsx)(n.code,{children:"IList"})," collection implementation but it was eventually\nreplaced with a version that uses ",(0,t.jsx)("a",{href:"https://pub.dev/packages/fast_immutable_collections",children:"Fast Immutable Collections"}),"\nunder the hood for performance reasons. Ribs only has an ",(0,t.jsx)(n.code,{children:"IList"}),", ",(0,t.jsx)(n.code,{children:"IMap"}),",\nand ",(0,t.jsx)(n.code,{children:"ISet"})," to maintain control over the public API which did not originally\nmatch the FIC API. Additionally, the API was designed to follow the Scala\n",(0,t.jsx)(n.code,{children:"List"}),", ",(0,t.jsx)(n.code,{children:"Map"}),", and ",(0,t.jsx)(n.code,{children:"Set"})," APIs as much as possible, to ease development of\nother Ribs libraries that were originally implemented in Scala."]}),(0,t.jsx)(n.p,{children:(0,t.jsxs)(n.strong,{children:["If you're interested in designing a fast and immutable collection in Dart,\nRibs is ",(0,t.jsx)(n.em,{children:"not"})," the place to look! Check out the FIC library!"]})})]}),"\n",(0,t.jsx)(n.admonition,{type:"tip",children:(0,t.jsx)(n.p,{children:"This page will only give a very short and incomplete example of each collection\ntype. It's highly recommended to explore the API for each collection type to\nget a better sense of what capabilities each provides."})}),"\n",(0,t.jsx)(n.h2,{id:"ilist",children:"IList"}),"\n",(0,t.jsx)(n.p,{children:"An ordered collection of 0 or more elements of the same type."}),"\n",(0,t.jsx)(s.O,{language:"dart",title:"IList Introduction",snippet:o,section:"ilist"}),"\n",(0,t.jsx)(n.h2,{id:"nonemptyilist",children:"NonEmptyIList"}),"\n",(0,t.jsxs)(n.p,{children:["An ordered collection of ",(0,t.jsx)(n.strong,{children:"1 or more"})," elements of the same type. The API\ngenerally follows that of ",(0,t.jsx)(n.code,{children:"IList"})," with a few modifications since it's known\nat compile time that it has at least one element."]}),"\n",(0,t.jsx)(s.O,{language:"dart",title:"NonEmptyIList Introduction",snippet:o,section:"nel"}),"\n",(0,t.jsx)(n.h2,{id:"imap",children:"IMap"}),"\n",(0,t.jsx)(n.p,{children:"A collection of Key-Value pairs. Values are typically accessed by providing\nthe associated key."}),"\n",(0,t.jsx)(s.O,{language:"dart",title:"IMap Introduction",snippet:o,section:"imap"}),"\n",(0,t.jsx)(n.h2,{id:"iset",children:"ISet"}),"\n",(0,t.jsxs)(n.p,{children:["A collection of ",(0,t.jsx)(n.em,{children:(0,t.jsx)(n.strong,{children:"unique"})})," element of the same type. There are no duplicate\nelements, as defined by each elements ",(0,t.jsx)(n.code,{children:"=="})," method."]}),"\n",(0,t.jsx)(s.O,{language:"dart",title:"ISet Introduction",snippet:o,section:"iset"})]})}const m=function(e={}){const{wrapper:n}=Object.assign({},(0,l.ah)(),e.components);return n?(0,t.jsx)(n,Object.assign({},e,{children:(0,t.jsx)(p,e)})):p(e)}}}]);