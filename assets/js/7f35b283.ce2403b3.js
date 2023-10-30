"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[664],{5274:(t,i,e)=>{e.r(i),e.d(i,{assets:()=>d,contentTitle:()=>c,default:()=>y,frontMatter:()=>a,metadata:()=>b,toc:()=>l});var n=e(5893),r=e(1151),s=e(4214);const o="// ignore_for_file: avoid_print\n\nimport 'dart:typed_data';\n\nimport 'package:ribs_binary/ribs_binary.dart';\n\n// bitvector-1\n\n// Creating ByteVectors\nfinal bytesA = ByteVector.empty();\nfinal bytesB = ByteVector.fromList([0, 12, 32]);\nfinal bytesC = ByteVector.low(10); // 10 bytes with all bits set to 0\nfinal bytesD = ByteVector.high(10); // 10 bytes with all bits set to 1\nfinal bytesE = ByteVector(Uint8List(10));\n\n// Creating BitVectors\nfinal bitsA = BitVector.empty();\nfinal bitsB = BitVector.fromByteVector(bytesA);\nfinal bitsC = BitVector.low(8); // 10 bits all set to 0\nfinal bitsD = BitVector.high(8); // 10 bits all set to 1\n\n// bitvector-1\n\nvoid snippet2() {\n  // bitvector-2\n\n  final bits =\n      BitVector.bits([true, false, true, true, false, false, true, true]);\n\n  print(bits.toBinString()); // 10110011\n  print('0x${bits.toHexString()}'); // 0xb3\n\n  bits.concat(bits); // combine 2 BitVectors\n  bits.drop(6); // drop the first 6 bits\n  bits.get(7); // get 7th bit\n  bits.clear(3); // set bit at index 3 to 0\n  bits.set(3); // set bit at index 3 to 1\n\n  // bitvector-2\n}\n",a={sidebar_position:1},c="BitVector",b={id:"binary/bit-vector",title:"BitVector",description:"Ribs binary provides 2 specialized data types for working with binary data:",source:"@site/docs/binary/bit-vector.mdx",sourceDirName:"binary",slug:"/binary/bit-vector",permalink:"/ribs/docs/binary/bit-vector",draft:!1,unlisted:!1,editUrl:"https://github.com/cranst0n/ribs/edit/main/website/docs/binary/bit-vector.mdx",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1},sidebar:"tutorialSidebar",previous:{title:"Streaming",permalink:"/ribs/docs/json/streaming"},next:{title:"Encoding and Decoding",permalink:"/ribs/docs/binary/encoding-and-decoding"}},d={},l=[];function p(t){const i=Object.assign({h1:"h1",p:"p",ul:"ul",li:"li",code:"code"},(0,r.ah)(),t.components);return(0,n.jsxs)(n.Fragment,{children:[(0,n.jsx)(i.h1,{id:"bitvector",children:"BitVector"}),"\n",(0,n.jsx)(i.p,{children:"Ribs binary provides 2 specialized data types for working with binary data:"}),"\n",(0,n.jsxs)(i.ul,{children:["\n",(0,n.jsxs)(i.li,{children:[(0,n.jsx)(i.code,{children:"ByteVector"}),": Indexed collection of bytes built on top of ",(0,n.jsx)(i.code,{children:"Uint8List"})]}),"\n",(0,n.jsxs)(i.li,{children:[(0,n.jsx)(i.code,{children:"BitVector"}),": Indexed collection of bits built on top of ",(0,n.jsx)(i.code,{children:"ByteVector"})]}),"\n"]}),"\n",(0,n.jsx)(i.p,{children:"The major difference between the 2 is what you're indexing into, bytes or bits."}),"\n",(0,n.jsx)(s.O,{language:"dart",title:"Creating Bit/Byte Vectors",snippet:o,section:"bitvector-1"}),"\n",(0,n.jsx)(i.p,{children:"Ribs also provides a rich API for manipulating these types:"}),"\n",(0,n.jsx)(s.O,{language:"dart",title:"BitVector API Sample",snippet:o,section:"bitvector-2"})]})}const y=function(t={}){const{wrapper:i}=Object.assign({},(0,r.ah)(),t.components);return i?(0,n.jsx)(i,Object.assign({},t,{children:(0,n.jsx)(p,t)})):p(t)}}}]);