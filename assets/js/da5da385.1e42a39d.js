"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[462],{3905:(t,e,r)=>{r.d(e,{Zo:()=>d,kt:()=>b});var n=r(7294);function a(t,e,r){return e in t?Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}):t[e]=r,t}function i(t,e){var r=Object.keys(t);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(t);e&&(n=n.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),r.push.apply(r,n)}return r}function o(t){for(var e=1;e<arguments.length;e++){var r=null!=arguments[e]?arguments[e]:{};e%2?i(Object(r),!0).forEach((function(e){a(t,e,r[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(r)):i(Object(r)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(r,e))}))}return t}function l(t,e){if(null==t)return{};var r,n,a=function(t,e){if(null==t)return{};var r,n,a={},i=Object.keys(t);for(n=0;n<i.length;n++)r=i[n],e.indexOf(r)>=0||(a[r]=t[r]);return a}(t,e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(t);for(n=0;n<i.length;n++)r=i[n],e.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(t,r)&&(a[r]=t[r])}return a}var s=n.createContext({}),p=function(t){var e=n.useContext(s),r=e;return t&&(r="function"==typeof t?t(e):o(o({},e),t)),r},d=function(t){var e=p(t.components);return n.createElement(s.Provider,{value:e},t.children)},c="mdxType",m={inlineCode:"code",wrapper:function(t){var e=t.children;return n.createElement(n.Fragment,{},e)}},u=n.forwardRef((function(t,e){var r=t.components,a=t.mdxType,i=t.originalType,s=t.parentName,d=l(t,["components","mdxType","originalType","parentName"]),c=p(r),u=a,b=c["".concat(s,".").concat(u)]||c[u]||m[u]||i;return r?n.createElement(b,o(o({ref:e},d),{},{components:r})):n.createElement(b,o({ref:e},d))}));function b(t,e){var r=arguments,a=e&&e.mdxType;if("string"==typeof t||a){var i=r.length,o=new Array(i);o[0]=u;var l={};for(var s in e)hasOwnProperty.call(e,s)&&(l[s]=e[s]);l.originalType=t,l[c]="string"==typeof t?t:a,o[1]=l;for(var p=2;p<i;p++)o[p]=r[p];return n.createElement.apply(null,o)}return n.createElement.apply(null,r)}u.displayName="MDXCreateElement"},5015:(t,e,r)=>{r.r(e),r.d(e,{assets:()=>s,contentTitle:()=>o,default:()=>m,frontMatter:()=>i,metadata:()=>l,toc:()=>p});var n=r(7462),a=(r(7294),r(3905));const i={sidebar_position:2},o="Acknowledgements",l={unversionedId:"acknowledgements",id:"acknowledgements",title:"Acknowledgements",description:"Ribs is built on the shoulders of giants. This project began out of a curiosity",source:"@site/docs/acknowledgements.md",sourceDirName:".",slug:"/acknowledgements",permalink:"/ribs/docs/acknowledgements",draft:!1,editUrl:"https://github.com/cranst0n/ribs/edit/main/website/docs/acknowledgements.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"tutorialSidebar",previous:{title:"Overview",permalink:"/ribs/docs/overview"},next:{title:"Functions",permalink:"/ribs/docs/core/functions"}},s={},p=[],d={toc:p},c="wrapper";function m(t){let{components:e,...r}=t;return(0,a.kt)(c,(0,n.Z)({},d,r,{components:e,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"acknowledgements"},"Acknowledgements"),(0,a.kt)("p",null,"Ribs is built on the shoulders of giants. This project began out of a curiosity\nof how advanced FP libraries work in the wild so I reviewed implementations from\nmany libraries I've used in Scala and worked on implementing them in Dart. Not\nonly did I learn a lot from them, some of the libraries provide capabilities\nthat don't otherwise exist in the Dart ecosystem (at the time of this writing)."),(0,a.kt)("p",null,"That being said, large portions of Ribs is directly derived from the following\nlibraries:"),(0,a.kt)("table",null,(0,a.kt)("thead",{parentName:"table"},(0,a.kt)("tr",{parentName:"thead"},(0,a.kt)("th",{parentName:"tr",align:null},"Library"),(0,a.kt)("th",{parentName:"tr",align:null},"Derived Work(s)"))),(0,a.kt)("tbody",{parentName:"table"},(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://github.com/typelevel/cats-effect"},"cats-effect")),(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("inlineCode",{parentName:"td"},"IO"),", ",(0,a.kt)("inlineCode",{parentName:"td"},"Ref")," and other effect related implementations")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://github.com/cb372/cats-retry"},"cats-retry")),(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("inlineCode",{parentName:"td"},"IO")," retry capabilities")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://github.com/typelevel/jawn"},"jawn")),(0,a.kt)("td",{parentName:"tr",align:null},"JSON parser")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://github.com/circe/circe"},"circe")),(0,a.kt)("td",{parentName:"tr",align:null},"JSON Encoding / Decoding")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://github.com/scodec/scodec"},"scodec")),(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("inlineCode",{parentName:"td"},"ByteVector"),", Binary Encoding / Decoding")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://www.optics.dev/Monocle/"},"monocle")),(0,a.kt)("td",{parentName:"tr",align:null},"Optics")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://github.com/typelevel/squants"},"sqaunts")),(0,a.kt)("td",{parentName:"tr",align:null},"Typesafe Dimensonal Analysis")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://github.com/wigahluk/dart-check"},"dart-check")),(0,a.kt)("td",{parentName:"tr",align:null},"Property based testing")))),(0,a.kt)("p",null,"In addition to these libraries, additional inspiration/motivation/credit is given to:"),(0,a.kt)("table",null,(0,a.kt)("thead",{parentName:"table"},(0,a.kt)("tr",{parentName:"thead"},(0,a.kt)("th",{parentName:"tr",align:null},"Library"),(0,a.kt)("th",{parentName:"tr",align:null}))),(0,a.kt)("tbody",{parentName:"table"},(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://pub.dev/packages/fast_immutable_collections"},"FIC")),(0,a.kt)("td",{parentName:"tr",align:null},"Amazing immutable collections library for Dart that Ribs uses under the hood of it's collections API.")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://github.com/spebbe/dartz"},"dartz")),(0,a.kt)("td",{parentName:"tr",align:null},"The OG Dart FP library where I made my first contributions to Dart.")),(0,a.kt)("tr",{parentName:"tbody"},(0,a.kt)("td",{parentName:"tr",align:null},(0,a.kt)("a",{parentName:"td",href:"https://github.com/SandroMaglione/fpdart"},"fpdart")),(0,a.kt)("td",{parentName:"tr",align:null},"The current de-facto FP library for Dart provides an amazing dev experience.")))),(0,a.kt)("p",null,"All of these libraries are worth exploring and represent tremendous value to\nthe entire Dart ecosystem! Much of what Ribs has become is directly possible\nwith these libraries."))}m.isMDXComponent=!0}}]);