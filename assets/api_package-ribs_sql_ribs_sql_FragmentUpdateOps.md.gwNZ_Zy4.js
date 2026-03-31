import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.bXlf-xsE.js";
const __pageData = JSON.parse('{"title":"FragmentUpdateOps","description":"API documentation for FragmentUpdateOps extension from ribs_sql","frontmatter":{"title":"FragmentUpdateOps","description":"API documentation for FragmentUpdateOps extension from ribs_sql","category":"Extensions","library":"ribs_sql","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_sql_ribs_sql/FragmentUpdateOps.md","filePath":"api/package-ribs_sql_ribs_sql/FragmentUpdateOps.md"}');
const _sfc_main = { name: "api/package-ribs_sql_ribs_sql/FragmentUpdateOps.md" };
const _hoisted_1 = {
  id: "prop-update0",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[4] || (_cache[4] = createStaticVNode('<h1 id="fragmentupdateops" tabindex="-1">FragmentUpdateOps <a class="header-anchor" href="#fragmentupdateops" aria-label="Permalink to &quot;FragmentUpdateOps&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">FragmentUpdateOps</span> <span class="kw">on</span> <a href="./Fragment" class="type-link">Fragment</a></code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("update0 ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[2] || (_cache[2] = createTextVNode()),
      _cache[3] || (_cache[3] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-update0",
        "aria-label": 'Permalink to "update0 <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-update0}"'
      }, "​", -1))
    ]),
    _cache[5] || (_cache[5] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Update0" class="type-link">Update0</a> <span class="kw">get</span> <span class="fn">update0</span></code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_sql_ribs_sql/Fragment.html">Fragment</a>, provided by the <a href="/ribs/api/package-ribs_sql_ribs_sql/FragmentUpdateOps.html">FragmentUpdateOps</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Update0</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> update0 </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Update0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(sql);</span></span></code></pre></div></details>', 3))
  ]);
}
const FragmentUpdateOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  FragmentUpdateOps as default
};
