#!/usr/bin/env node
// Repo-wide sweep for redundant C# usings that Roslyn (CS8019/IDE0005) misses.
//
//   node sweep-redundant-usings.mjs          # report only
//   node sweep-redundant-usings.mjs --fix    # remove the deterministic [REDUNDANT] class
//
// Run from the repo root. Auto-discovers every GlobalUsings.cs via git.
import fs from "node:fs";
import { execSync } from "node:child_process";

const FIX = process.argv.includes("--fix");

// Extension-method-only namespaces Roslyn conservatively retains -> member tokens
// that signal genuine use. Reported as [VERIFY]; never auto-removed.
const EXT = {
  "System.Net.Http.Json": ["FromJsonAsync", "AsJsonAsync", "ReadFromJson", "JsonContent"],
  "System.Linq": [".Select", ".Where", ".Any(", ".All(", ".First", ".Single", ".ToList",
    ".ToArray", ".OrderBy", ".GroupBy", ".Sum(", ".Count(", ".Max(", ".Min(", ".Average(",
    ".Aggregate", ".Distinct", ".Skip(", ".Take(", ".SelectMany", ".Contains(", ".ToDictionary",
    ".Concat(", ".Zip(", ".SequenceEqual", ".Cast<", ".OfType<", ".Append(", ".Prepend(",
    ".Chunk(", ".Union(", ".Except(", ".Intersect(", ".ElementAt", ".DistinctBy", ".MaxBy", ".MinBy"],
  "Microsoft.EntityFrameworkCore": ["ToListAsync", "FirstOrDefaultAsync", "SingleOrDefaultAsync",
    "FindAsync", "Include(", "ThenInclude", "AsNoTracking", "ExecuteDelete", "ExecuteUpdate",
    "ToArrayAsync", "AnyAsync", "CountAsync", "SumAsync", "SaveChangesAsync", "FromSqlRaw",
    "FromSqlInterpolated", "ExecuteSqlRaw", "UseSqlServer", "UseSqlite", "EnableRetry", "Migrate",
    "DbUpdateConcurrencyException", "DbUpdateException", "EntityState", "Set<", "Entry("],
  "System.Linq.Expressions": ["Expression<", "Expression."],
};

const usingRe = /^\s*using\s+(?!static)([A-Za-z0-9_.]+)\s*;\s*$/;
const ls = (pat) => execSync(`git ls-files "${pat}"`, { encoding: "utf8" }).split(/\r?\n/).filter(Boolean);

// Discover project-scoped global usings: dir -> Set(namespaces).
const globalDirs = [];
for (const gf of ls("*GlobalUsings.cs")) {
  const dir = gf.replace(/\/?GlobalUsings\.cs$/, "");
  const set = new Set();
  for (const l of fs.readFileSync(gf, "utf8").split(/\r?\n/)) {
    const m = l.match(/^\s*global\s+using\s+(?!static)([A-Za-z0-9_.]+)\s*;/);
    if (m) set.add(m[1]);
  }
  globalDirs.push({ dir, set });
}
// Longest-prefix match -> the project root governing a given file.
const globalsFor = (f) => {
  let best = null;
  for (const g of globalDirs) {
    const prefix = g.dir === "" ? "" : g.dir + "/";
    if (f.startsWith(prefix) && (!best || g.dir.length > best.dir.length)) best = g;
  }
  return best ? best.set : new Set();
};

const redundant = []; // {f, line, ns}  deterministic
const verify = [];     // {f, line, ns}  heuristic

for (const f of ls("*.cs")) {
  if (/GlobalUsings\.cs$/.test(f)) continue;
  if (/(^|\/)Migrations\//.test(f) || /\.Designer\.cs$/.test(f)) continue; // EF-generated, never hand-edit
  const raw = fs.readFileSync(f, "utf8");
  const nl = raw.includes("\r\n") ? "\r\n" : "\n";
  const lines = raw.split(/\r?\n/);
  const g = globalsFor(f);
  const body = lines.filter((l) => !usingRe.test(l)).join("\n");

  const kept = [];
  lines.forEach((l, i) => {
    const m = l.match(usingRe);
    if (m) {
      const ns = m[1];
      if (g.has(ns)) { redundant.push({ f, line: i + 1, ns }); return; } // drop
      if (ns in EXT && !EXT[ns].some((t) => body.includes(t))) verify.push({ f, line: i + 1, ns });
    }
    kept.push(l);
  });

  if (FIX && kept.length !== lines.length) fs.writeFileSync(f, kept.join(nl));
}

const fmt = (a) => a.map((h) => `  ${h.f}:${h.line}  ${h.ns}`).join("\n") || "  (none)";
console.log(`[REDUNDANT] local using duplicates a global using  ${FIX ? "(removed)" : "(use --fix to remove)"}`);
console.log(fmt(redundant));
console.log(`\n[VERIFY] extension-method namespace, no members referenced — check by hand`);
console.log(fmt(verify));
console.log(`\n${redundant.length} redundant, ${verify.length} to verify.`);
