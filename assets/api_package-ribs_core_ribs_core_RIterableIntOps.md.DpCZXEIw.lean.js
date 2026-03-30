import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.Bx1PjHTn.js";
const __pageData = JSON.parse('{"title":"RIterableIntOps","description":"API documentation for RIterableIntOps extension from ribs_core","frontmatter":{"title":"RIterableIntOps","description":"API documentation for RIterableIntOps extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/RIterableIntOps.md","filePath":"api/package-ribs_core_ribs_core/RIterableIntOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/RIterableIntOps.md" };
const _hoisted_1 = {
  id: "product",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "sum",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[6] || (_cache[6] = createStaticVNode("", 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("product() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#product",
        "aria-label": 'Permalink to "product() <Badge type="info" text="extension" /> {#product}"'
      }, "​", -1))
    ]),
    _cache[7] || (_cache[7] = createStaticVNode("", 4)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("sum() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#sum",
        "aria-label": 'Permalink to "sum() <Badge type="info" text="extension" /> {#sum}"'
      }, "​", -1))
    ]),
    _cache[8] || (_cache[8] = createStaticVNode("", 4))
  ]);
}
const RIterableIntOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  RIterableIntOps as default
};
