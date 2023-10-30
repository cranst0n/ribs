"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[435],{1696:(n,e,s)=>{s.r(e),s.d(e,{assets:()=>l,contentTitle:()=>c,default:()=>h,frontMatter:()=>a,metadata:()=>d,toc:()=>g});var t=s(5893),i=s(1151),o=s(4214);const r='import \'package:ribs_json/ribs_json.dart\';\n\n// creating-1\n\nfinal anObject = Json.obj([\n  (\'key1\', Json.True),\n  (\'key2\', Json.str(\'some string...\')),\n  (\n    \'key3\',\n    Json.arr([\n      Json.number(123),\n      Json.number(3.14),\n    ])\n  ),\n]);\n\n// creating-1\n\n// creating-2\n\nfinal jsonString = anObject.printWith(Printer.noSpaces);\n// {"key1":true,"key2":"some string...","key3":[123,3.14]}\n\nfinal prettyJsonString = anObject.printWith(Printer.spaces2);\n// {\n//   "key1" : true,\n//   "key2" : "some string...",\n//   "key3" : [\n//     123,\n//     3.14\n//   ]\n// }\n\n// creating-2\n',a={sidebar_position:2},c="Creating JSON",d={id:"json/creating-json",title:"Creating JSON",description:"It's also easy to create a typed JSON structure using Ribs using the Json",source:"@site/docs/json/creating-json.mdx",sourceDirName:"json",slug:"/json/creating-json",permalink:"/ribs/docs/json/creating-json",draft:!1,unlisted:!1,editUrl:"https://github.com/cranst0n/ribs/edit/main/website/docs/json/creating-json.mdx",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"tutorialSidebar",previous:{title:"Parsing JSON",permalink:"/ribs/docs/json/parsing-json"},next:{title:"Encoding and Decoding",permalink:"/ribs/docs/json/encoding-and-decoding"}},l={},g=[];function j(n){const e=Object.assign({h1:"h1",p:"p",code:"code",admonition:"admonition"},(0,i.ah)(),n.components);return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(e.h1,{id:"creating-json",children:"Creating JSON"}),"\n",(0,t.jsxs)(e.p,{children:["It's also easy to create a typed JSON structure using Ribs using the ",(0,t.jsx)(e.code,{children:"Json"}),"\nclass:"]}),"\n",(0,t.jsx)(o.O,{language:"dart",title:"JSON Object",snippet:r,section:"creating-1"}),"\n",(0,t.jsxs)(e.p,{children:["By passing a list of ",(0,t.jsx)(e.code,{children:"(String, Json)"})," elements to the ",(0,t.jsx)(e.code,{children:"Json.obj"})," function, we now have a fully\ntyped ",(0,t.jsx)(e.code,{children:"Json"})," object that we can interact with using the Ribs json API."]}),"\n",(0,t.jsx)(e.admonition,{type:"info",children:(0,t.jsxs)(e.p,{children:["In many cases, you probably won't need to use the ",(0,t.jsx)(e.code,{children:"Json"})," API itself. It's far\nmore common to define your domain models, and create encoders and decoders\nfor those. But it's still worthwhile knowing the ",(0,t.jsx)(e.code,{children:"Json"})," type is what makes the\nhigher level APIs work."]})}),"\n",(0,t.jsx)(e.p,{children:"What about serializing the JSON? That's also an easy task:"}),"\n",(0,t.jsx)(o.O,{language:"dart",title:"Serialzing Json to String",snippet:r,section:"creating-2"})]})}const h=function(n={}){const{wrapper:e}=Object.assign({},(0,i.ah)(),n.components);return e?(0,t.jsx)(e,Object.assign({},n,{children:(0,t.jsx)(j,n)})):j(n)}}}]);