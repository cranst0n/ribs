import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.CNYu8dAD.js";
const __pageData = JSON.parse('{"title":"With1","description":"API documentation for With1<A> extension type from ribs_parse","frontmatter":{"title":"With1<A>","description":"API documentation for With1<A> extension type from ribs_parse","category":"Extension Types","library":"ribs_parse","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_parse_ribs_parse/With1.md","filePath":"api/package-ribs_parse_ribs_parse/With1.md"}');
const _sfc_main = { name: "api/package-ribs_parse_ribs_parse/With1.md" };
const _hoisted_1 = {
  id: "prop-parser",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-soft",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[6] || (_cache[6] = createStaticVNode("", 6)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("parser ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-parser",
        "aria-label": 'Permalink to "parser <Badge type="tip" text="final" /> {#prop-parser}"'
      }, "​", -1))
    ]),
    _cache[7] || (_cache[7] = createStaticVNode("", 1)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("soft ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-soft",
        "aria-label": 'Permalink to "soft <Badge type="tip" text="no setter" /> {#prop-soft}"'
      }, "​", -1))
    ]),
    _cache[8] || (_cache[8] = createStaticVNode("", 21))
  ]);
}
const With1 = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  With1 as default
};
