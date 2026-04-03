import { o as openBlock, c as createElementBlock, b as createBaseVNode, d as createTextVNode, _ as _export_sfc } from "./app.BTZccDEf.js";
const __pageData = JSON.parse('{"title":"Guide","description":"","frontmatter":{},"headers":[],"relativePath":"guide/index.md","filePath":"guide/index.md"}');
const _sfc_main = { name: "guide/index.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", null, [..._cache[0] || (_cache[0] = [
    createBaseVNode("h1", {
      id: "guide",
      tabindex: "-1"
    }, [
      createTextVNode("Guide "),
      createBaseVNode("a", {
        class: "header-anchor",
        href: "#guide",
        "aria-label": 'Permalink to "Guide"'
      }, "​")
    ], -1),
    createBaseVNode("p", null, [
      createTextVNode("Welcome to the "),
      createBaseVNode("strong", null, "ribs_workspace"),
      createTextVNode(" documentation.")
    ], -1)
  ])]);
}
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  index as default
};
