import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.Bo4QfGNf.js";
const __pageData = JSON.parse('{"title":"Function1Ops<T0, T1>","description":"API documentation for Function1Ops<T0, T1> extension from ribs_core","frontmatter":{"title":"Function1Ops<T0, T1>","description":"API documentation for Function1Ops<T0, T1> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/Function1Ops.md","filePath":"api/package-ribs_core_ribs_core/Function1Ops.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/Function1Ops.md" };
const _hoisted_1 = {
  id: "andthen",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "compose",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[6] || (_cache[6] = createStaticVNode("", 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("andThen() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#andthen",
        "aria-label": 'Permalink to "andThen() <Badge type="info" text="extension" /> {#andthen}"'
      }, "​", -1))
    ]),
    _cache[7] || (_cache[7] = createStaticVNode("", 4)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("compose() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#compose",
        "aria-label": 'Permalink to "compose() <Badge type="info" text="extension" /> {#compose}"'
      }, "​", -1))
    ]),
    _cache[8] || (_cache[8] = createStaticVNode("", 4))
  ]);
}
const Function1Ops = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Function1Ops as default
};
