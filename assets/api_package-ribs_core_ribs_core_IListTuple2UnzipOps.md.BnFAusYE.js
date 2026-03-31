import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.BvG9boA-.js";
const __pageData = JSON.parse('{"title":"IListTuple2UnzipOps<A, B>","description":"API documentation for IListTuple2UnzipOps<A, B> extension from ribs_core","frontmatter":{"title":"IListTuple2UnzipOps<A, B>","description":"API documentation for IListTuple2UnzipOps<A, B> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/IListTuple2UnzipOps.md","filePath":"api/package-ribs_core_ribs_core/IListTuple2UnzipOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/IListTuple2UnzipOps.md" };
const _hoisted_1 = {
  id: "unzip",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="ilisttuple2unzipops-a-b" tabindex="-1">IListTuple2UnzipOps&lt;A, B&gt; <a class="header-anchor" href="#ilisttuple2unzipops-a-b" aria-label="Permalink to &quot;IListTuple2UnzipOps\\&lt;A, B\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">IListTuple2UnzipOps</span>&lt;A, B&gt; <span class="kw">on</span> <a href="./IList" class="type-link">IList</a>&lt;<span class="type">Record</span>&gt;</code></pre></div><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("unzip() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#unzip",
        "aria-label": 'Permalink to "unzip() <Badge type="info" text="extension" /> {#unzip}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Record</span> <span class="fn">unzip</span>()</code></pre></div><p>Returns 2 new lists as a tuple. The first list is all the first items from each tuple element of this list. The second list is all the second items from each tuple element of this list.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/IList.html">IList&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/IListTuple2UnzipOps.html">IListTuple2UnzipOps&lt;A, B&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;) </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unzip</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    foldLeft</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nil</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(), </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nil</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;()), (acc, ab) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (acc.$1.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">appended</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ab.$1), acc.$2.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">appended</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ab.$2)));</span></span></code></pre></div></details>', 4))
  ]);
}
const IListTuple2UnzipOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  IListTuple2UnzipOps as default
};
