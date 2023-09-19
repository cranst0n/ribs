"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[174],{2818:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>m,contentTitle:()=>d,default:()=>b,frontMatter:()=>s,metadata:()=>c,toc:()=>l});var i=n(7462),a=(n(7294),n(3905)),r=n(4214);const o="// ignore_for_file: unused_local_variable\n\nimport 'dart:io';\n\nimport 'package:ribs_binary/ribs_binary.dart';\n\n/// streaming-1\n\nfinal class Event {\n  final DateTime timestamp;\n  final int id;\n  final String message;\n\n  const Event(this.timestamp, this.id, this.message);\n\n  static final codec = Codec.product3(\n    int64.xmap(\n      (i) => DateTime.fromMillisecondsSinceEpoch(i),\n      (date) => date.millisecondsSinceEpoch,\n    ),\n    uint24,\n    utf8_32,\n    Event.new,\n    (evt) => (evt.timestamp, evt.id, evt.message),\n  );\n}\n\n/// streaming-1\n\nFuture<void> snippet2() async {\n  /// streaming-2\n\n  Stream<Event> events() => throw UnimplementedError('TODO');\n\n  final socket = await Socket.connect('localhost', 12345);\n\n  final Future<void> eventWriter = events()\n      // Encodes each Event to BitVector\n      .transform(StreamEncoder(Event.codec))\n      // Convert BitVector to Uint8List\n      .map((bitVector) => bitVector.toByteArray())\n      // Write each Uint8List to Socket\n      .forEach((byteList) => socket.add(byteList));\n\n  /// streaming-2\n}\n\nFuture<void> snippet3() async {\n  /// streaming-3\n  void storeEvent(Event evt) => throw UnimplementedError('TODO');\n\n  Future<void> handleClient(Socket clientSocket) => clientSocket\n      // Convert Uint8List to BitVector\n      .map((bytes) => ByteVector(bytes).bits)\n      // Convert BitVector to Event\n      .transform(StreamDecoder(Event.codec))\n      // Do something with the events\n      .forEach(storeEvent);\n\n  final socket = await ServerSocket.bind('0.0.0.0', 12345);\n  final events = socket.forEach(handleClient);\n\n  /// streaming-3\n}\n",s={sidebar_position:3},d="Streaming",c={unversionedId:"binary/streaming",id:"binary/streaming",title:"Streaming",description:"It's a common scenario to read and write bytes to and from file, socket or",source:"@site/docs/binary/streaming.mdx",sourceDirName:"binary",slug:"/binary/streaming",permalink:"/ribs/docs/binary/streaming",draft:!1,editUrl:"https://github.com/cranst0n/ribs/edit/main/website/docs/binary/streaming.mdx",tags:[],version:"current",sidebarPosition:3,frontMatter:{sidebar_position:3},sidebar:"tutorialSidebar",previous:{title:"Encoding and Decoding",permalink:"/ribs/docs/binary/encoding-and-decoding"},next:{title:"Iso",permalink:"/ribs/docs/optics/iso"}},m={},l=[{value:"StreamEncoder",id:"streamencoder",level:2},{value:"StreamDecoder",id:"streamdecoder",level:2}],p={toc:l},g="wrapper";function b(e){let{components:t,...n}=e;return(0,a.kt)(g,(0,i.Z)({},p,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"streaming"},"Streaming"),(0,a.kt)("p",null,"It's a common scenario to read and write bytes to and from file, socket or\nsome other ",(0,a.kt)("inlineCode",{parentName:"p"},"Stream"),". Ribs provides the 2 basic tools to handle the machinery\nnecessary for these situations."),(0,a.kt)("p",null,"Let's assume we've got a simple type of model with our binary ",(0,a.kt)("inlineCode",{parentName:"p"},"Codec")," already\ndefined:"),(0,a.kt)(r.O,{language:"dart",title:"Domain Model",snippet:o,section:"streaming-1",mdxType:"CodeSnippet"}),(0,a.kt)("h2",{id:"streamencoder"},"StreamEncoder"),(0,a.kt)("p",null,"Now image we generate these events on the fly and need to send them out a\nsocket after converting them to binary. ",(0,a.kt)("inlineCode",{parentName:"p"},"StreamEncoder")," is the perfect\nsolution:"),(0,a.kt)(r.O,{language:"dart",title:"StreamEncoder",snippet:o,section:"streaming-2",mdxType:"CodeSnippet"}),(0,a.kt)("p",null,"We've built a capable yet expressive and readable program with minimal effort!"),(0,a.kt)("h2",{id:"streamdecoder"},"StreamDecoder"),(0,a.kt)("p",null,"Now we can imagine needing to write a program that will receive events off a\nsocket and do something meaningful with them:"),(0,a.kt)(r.O,{language:"dart",title:"StreamEncoder",snippet:o,section:"streaming-3",mdxType:"CodeSnippet"}),(0,a.kt)("p",null,"Using the Ribs Binary streaming API, it's easy to transform byte streams into\nyour domain objects."))}b.isMDXComponent=!0}}]);