import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.CLTcByCu.js";
const __pageData = JSON.parse('{"title":"RillCompilerStringOps","description":"API documentation for RillCompilerStringOps extension from ribs_rill","frontmatter":{"title":"RillCompilerStringOps","description":"API documentation for RillCompilerStringOps extension from ribs_rill","category":"Extensions","library":"ribs_rill","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_rill_ribs_rill/RillCompilerStringOps.md","filePath":"api/package-ribs_rill_ribs_rill/RillCompilerStringOps.md"}');
const _sfc_main = { name: "api/package-ribs_rill_ribs_rill/RillCompilerStringOps.md" };
const _hoisted_1 = {
  id: "prop-string",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[4] || (_cache[4] = createStaticVNode("", 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("string ", -1)),
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
        href: "#prop-string",
        "aria-label": 'Permalink to "string <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-string}"'
      }, "​", -1))
    ]),
    _cache[5] || (_cache[5] = createStaticVNode("", 3))
  ]);
}
const RillCompilerStringOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  RillCompilerStringOps as default
};
