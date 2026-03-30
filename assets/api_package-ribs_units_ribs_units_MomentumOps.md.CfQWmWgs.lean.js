import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.VOIEn6c-.js";
const __pageData = JSON.parse('{"title":"MomentumOps","description":"API documentation for MomentumOps extension from ribs_units","frontmatter":{"title":"MomentumOps","description":"API documentation for MomentumOps extension from ribs_units","category":"Extensions","library":"ribs_units","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_units_ribs_units/MomentumOps.md","filePath":"api/package-ribs_units_ribs_units/MomentumOps.md"}');
const _sfc_main = { name: "api/package-ribs_units_ribs_units/MomentumOps.md" };
const _hoisted_1 = {
  id: "prop-newtonseconds",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-poundforceseconds",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[8] || (_cache[8] = createStaticVNode("", 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("newtonSeconds ", -1)),
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
        href: "#prop-newtonseconds",
        "aria-label": 'Permalink to "newtonSeconds <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-newtonseconds}"'
      }, "​", -1))
    ]),
    _cache[9] || (_cache[9] = createStaticVNode("", 3)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[4] || (_cache[4] = createTextVNode("poundForceSeconds ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[5] || (_cache[5] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[6] || (_cache[6] = createTextVNode()),
      _cache[7] || (_cache[7] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-poundforceseconds",
        "aria-label": 'Permalink to "poundForceSeconds <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-poundforceseconds}"'
      }, "​", -1))
    ]),
    _cache[10] || (_cache[10] = createStaticVNode("", 3))
  ]);
}
const MomentumOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  MomentumOps as default
};
