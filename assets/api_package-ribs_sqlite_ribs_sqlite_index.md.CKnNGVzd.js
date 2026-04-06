import { o as openBlock, c as createElementBlock, e as createStaticVNode, _ as _export_sfc } from "./app.GJ9uE4Mh.js";
const __pageData = JSON.parse('{"title":"ribs_sqlite","description":"API documentation for the ribs_sqlite library","frontmatter":{"title":"ribs_sqlite","description":"API documentation for the ribs_sqlite library","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_sqlite_ribs_sqlite/index.md","filePath":"api/package-ribs_sqlite_ribs_sqlite/index.md"}');
const _sfc_main = { name: "api/package-ribs_sqlite_ribs_sqlite/index.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", null, [..._cache[0] || (_cache[0] = [
    createStaticVNode('<h1 id="ribs-sqlite" tabindex="-1">ribs_sqlite <a class="header-anchor" href="#ribs-sqlite" aria-label="Permalink to &quot;ribs_sqlite&quot;">​</a></h1><p>SQLite driver integration for <code>ribs_sql</code>.</p><p>Provides a <a href="../package-ribs_sql_ribs_sql/Transactor.html" class="api-link"><code>Transactor</code></a> and connection abstractions for executing purely functional, type-safe SQL queries against SQLite databases.</p><h2 id="section-classes" tabindex="-1">Classes <a class="header-anchor" href="#section-classes" aria-label="Permalink to &quot;Classes {#section-classes}&quot;">​</a></h2><table tabindex="0"><thead><tr><th>Class</th><th>Description</th></tr></thead><tbody><tr><td><a href="/ribs/api/package-ribs_sqlite_ribs_sqlite/SqliteConnection.html">SqliteConnection</a></td><td>A <a href="/ribs/api/package-ribs_sql_ribs_sql/SqlConnection.html">SqlConnection</a> backed directly by a <code>sqlite3</code> <a href="https://pub.dev/documentation/sqlite3/3.3.0/sqlite3/Database-class.html" target="_blank" rel="noreferrer">Database</a> instance.</td></tr><tr><td><a href="/ribs/api/package-ribs_sqlite_ribs_sqlite/SqlitePoolTransactor.html">SqlitePoolTransactor</a></td><td>A <a href="/ribs/api/package-ribs_sql_ribs_sql/Transactor.html">Transactor</a> backed by a SQLite connection pool via the <code>sqlite3_connection_pool</code> package.</td></tr><tr><td><a href="/ribs/api/package-ribs_sqlite_ribs_sqlite/SqliteTransactor.html">SqliteTransactor</a></td><td>A <a href="/ribs/api/package-ribs_sql_ribs_sql/Transactor.html">Transactor</a> backed by an SQLite database via the <code>sqlite3</code> package.</td></tr></tbody></table>', 5)
  ])]);
}
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  index as default
};
