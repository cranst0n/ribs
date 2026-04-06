import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.I8Q2zGvD.js";
const __pageData = JSON.parse('{"title":"IListNullableOps","description":"API documentation for IListNullableOps<A> extension from ribs_core","frontmatter":{"title":"IListNullableOps<A>","description":"API documentation for IListNullableOps<A> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/IListNullableOps.md","filePath":"api/package-ribs_core_ribs_core/IListNullableOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/IListNullableOps.md" };
const _hoisted_1 = {
  id: "nonulls",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode("", 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("noNulls() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nonulls",
        "aria-label": 'Permalink to "noNulls() <Badge type="info" text="extension" /> {#nonulls}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode("", 4))
  ]);
}
const IListNullableOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  IListNullableOps as default
};
