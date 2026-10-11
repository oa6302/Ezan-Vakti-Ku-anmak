const $ = id => document.getElementById(id);
const categoryNames = { risale: "Risale-i Nur", ayet: "Ayet", hadis: "Hadis" };
let records = [];
let currentPage = "overview";

function showPage(page) {
  currentPage = page;
  document.querySelectorAll(".nav").forEach(b => b.classList.toggle("active", b.dataset.page === page));
  $("overviewPage").classList.toggle("hidden", page !== "overview");
  $("editorPage").classList.add("hidden");
  $("placeholderPage").classList.toggle("hidden", !["home","notifications","settings"].includes(page));
  const titles = {overview:"Genel Bakış",risale:"Risale-i Nur",ayet:"Ayetler",hadis:"Hadisler",home:"Ana Sayfa Yönetimi",notifications:"Bildirimler",settings:"Ayarlar"};
  $("pageTitle").textContent = titles[page] || "Yönetim";
  $("placeholderTitle").textContent = titles[page] || "Bölüm";
  if (["risale","ayet","hadis"].includes(page)) {
    $("categoryFilter").value = page;
    render();
  } else if (page === "overview") {
    $("categoryFilter").value = "all";
    render();
  }
}
document.querySelectorAll(".nav").forEach(b => b.addEventListener("click", () => showPage(b.dataset.page)));

function render() {
  const q = $("searchInput").value.trim().toLocaleLowerCase("tr-TR");
  const cat = $("categoryFilter").value;
  const status = $("statusFilter").value;
  const filtered = records.filter(r =>
    (cat === "all" || r.category === cat) &&
    (status === "all" || r.status === status) &&
    `${r.title} ${r.source} ${r.reference}`.toLocaleLowerCase("tr-TR").includes(q)
  );
  $("contentRows").innerHTML = filtered.map(r => `
    <tr>
      <td><strong>${escapeHtml(r.title)}</strong><small>${escapeHtml((r.modern || "").slice(0,72))}</small></td>
      <td><span class="tag">${categoryNames[r.category]}</span></td>
      <td>${escapeHtml(r.source || "Kaynak girilmedi")}<br><small>${escapeHtml(r.reference || "")}</small></td>
      <td><span class="tag ${r.status === "published" ? "published" : ""}">${r.status === "published" ? "Yayınlandı · demo" : "Taslak"}</span></td>
      <td><button class="row-action" data-edit="${r.id}">Düzenle</button></td>
    </tr>`).join("");
  $("emptyState").classList.toggle("hidden", filtered.length > 0);
  $("risaleCount").textContent = records.filter(r=>r.category==="risale").length;
  $("ayetCount").textContent = records.filter(r=>r.category==="ayet").length;
  $("hadisCount").textContent = records.filter(r=>r.category==="hadis").length;
  $("publishedCount").textContent = records.filter(r=>r.status==="published").length;
  document.querySelectorAll("[data-edit]").forEach(b => b.addEventListener("click", () => openEditor(b.dataset.edit)));
}
function escapeHtml(value) {
  return String(value ?? "").replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
}
function openEditor(id = "") {
  $("contentForm").reset();
  $("recordId").value = id;
  const r = records.find(x => x.id === id);
  $("editorHeading").textContent = r ? "İçeriği düzenle" : "Yeni içerik";
  $("deleteRecord").classList.toggle("hidden", !r);
  if (r) {
    for (const key of ["title","category","ottoman","modern","reflection","source","reference","sourceUrl","status"]) {
      $(key).value = r[key] || (key === "status" ? "draft" : "");
    }
  }
  updateOttoman();
  $("overviewPage").classList.add("hidden");
  $("placeholderPage").classList.add("hidden");
  $("editorPage").classList.remove("hidden");
  $("pageTitle").textContent = r ? "İçerik düzenleme" : "Yeni içerik";
}
function updateOttoman() {
  $("ottomanGroup").classList.toggle("hidden", $("category").value !== "risale");
}
$("category").addEventListener("change", updateOttoman);
$("newContent").addEventListener("click", () => openEditor());
$("cancelEditor").addEventListener("click", () => showPage(currentPage === "overview" ? "overview" : currentPage));
$("searchInput").addEventListener("input", render);
$("categoryFilter").addEventListener("change", render);
$("statusFilter").addEventListener("change", render);

$("contentForm").addEventListener("submit", event => {
  event.preventDefault();
  const id = $("recordId").value || (crypto.randomUUID ? crypto.randomUUID() : String(Date.now()));
  const record = { id };
  for (const key of ["title","category","ottoman","modern","reflection","source","reference","sourceUrl","status"]) record[key] = $(key).value.trim();
  const index = records.findIndex(r => r.id === id);
  if (index >= 0) records[index] = record; else records.unshift(record);
  alert("Bu yalnızca önizleme oturumundaki bir deneme kaydıdır. Sunucuya kaydedilmedi.");
  showPage("overview");
});
$("deleteRecord").addEventListener("click", () => {
  const id = $("recordId").value;
  if (!id || !confirm("Bu deneme kaydını silmek istiyor musunuz?")) return;
  records = records.filter(r => r.id !== id);
  showPage("overview");
});
render();
