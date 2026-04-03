import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.Bype-fSc.js";
const __pageData = JSON.parse('{"title":"ParameterizedQueryStringOps","description":"API documentation for ParameterizedQueryStringOps extension from ribs_sql","frontmatter":{"title":"ParameterizedQueryStringOps","description":"API documentation for ParameterizedQueryStringOps extension from ribs_sql","category":"Extensions","library":"ribs_sql","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_sql_ribs_sql/ParameterizedQueryStringOps.md","filePath":"api/package-ribs_sql_ribs_sql/ParameterizedQueryStringOps.md"}');
const _sfc_main = { name: "api/package-ribs_sql_ribs_sql/ParameterizedQueryStringOps.md" };
const _hoisted_1 = {
  id: "parmeteriedquery",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode("", 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("parmeteriedQuery() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#parmeteriedquery",
        "aria-label": 'Permalink to "parmeteriedQuery() <Badge type="info" text="extension" /> {#parmeteriedquery}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode("", 4))
  ]);
}
const ParameterizedQueryStringOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  ParameterizedQueryStringOps as default
};
