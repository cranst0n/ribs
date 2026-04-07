import { o as openBlock, c as createElementBlock, a as createStaticVNode, _ as _export_sfc } from "./app.in0HSMfJ.js";
const __pageData = JSON.parse('{"title":"AsyncBodyWithFin typedef","description":"API documentation for the AsyncBodyWithFin<A> typedef from ribs_effect","frontmatter":{"title":"AsyncBodyWithFin<A> typedef","description":"API documentation for the AsyncBodyWithFin<A> typedef from ribs_effect","category":"Typedefs","library":"ribs_effect","outline":false,"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_effect_ribs_effect/AsyncBodyWithFin.md","filePath":"api/package-ribs_effect_ribs_effect/AsyncBodyWithFin.md"}');
const _sfc_main = { name: "api/package-ribs_effect_ribs_effect/AsyncBodyWithFin.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", null, [..._cache[0] || (_cache[0] = [
    createStaticVNode('<h1 id="asyncbodywithfin-a" tabindex="-1">AsyncBodyWithFin&lt;A&gt; <a class="header-anchor" href="#asyncbodywithfin-a" aria-label="Permalink to &quot;AsyncBodyWithFin\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">typedef</span> <span class="fn">AsyncBodyWithFin&lt;A&gt;</span> = <a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Unit" class="type-link">Unit</a>&gt;&gt;&gt; <span class="type">Function</span>(\n  <span class="type">void</span> <span class="type">Function</span>(<a href="../package-ribs_core_ribs_core/Either" class="type-link">Either</a>&lt;<span class="type">Object</span>, <span class="type">A</span>&gt;),\n)</code></pre></div><p>Like <a href="/ribs/api/package-ribs_effect_ribs_effect/AsyncBody.html">AsyncBody</a>, but also returns an optional <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO</a> finalizer that is invoked if the resulting <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO</a> is canceled, used by <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html#async">IO.async</a>.</p>', 3)
  ])]);
}
const AsyncBodyWithFin = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  AsyncBodyWithFin as default
};
