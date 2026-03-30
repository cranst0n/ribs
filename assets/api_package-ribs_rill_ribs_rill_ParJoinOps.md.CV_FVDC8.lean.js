import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.DEU85t31.js";
const __pageData = JSON.parse('{"title":"ParJoinOps","description":"API documentation for ParJoinOps<O> extension from ribs_rill","frontmatter":{"title":"ParJoinOps<O>","description":"API documentation for ParJoinOps<O> extension from ribs_rill","category":"Extensions","library":"ribs_rill","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_rill_ribs_rill/ParJoinOps.md","filePath":"api/package-ribs_rill_ribs_rill/ParJoinOps.md"}');
const _sfc_main = { name: "api/package-ribs_rill_ribs_rill/ParJoinOps.md" };
const _hoisted_1 = {
  id: "parjoin",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "parjoinunbounded",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[6] || (_cache[6] = createStaticVNode("", 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("parJoin() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#parjoin",
        "aria-label": 'Permalink to "parJoin() <Badge type="info" text="extension" /> {#parjoin}"'
      }, "​", -1))
    ]),
    _cache[7] || (_cache[7] = createStaticVNode("", 5)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("parJoinUnbounded() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#parjoinunbounded",
        "aria-label": 'Permalink to "parJoinUnbounded() <Badge type="info" text="extension" /> {#parjoinunbounded}"'
      }, "​", -1))
    ]),
    _cache[8] || (_cache[8] = createStaticVNode("", 3))
  ]);
}
const ParJoinOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  ParJoinOps as default
};
