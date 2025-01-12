function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

function txt2bib(str)
  lines, bib_str = [], ""
  open(str) do f
    for l in eachline(f)
      splt = split(l)
      length(splt) > 0 && push!(lines, split(l))
    end
  end
  AF = findfirst(l -> l[1] == "AF", lines)
  TI = findfirst(l -> l[1] == "TI", lines)
  SO = findfirst(l -> l[1] == "SO", lines)
  VL = findfirst(l -> l[1] == "VL", lines)
  BP = findfirst(l -> l[1] == "BP", lines)
  EP = findfirst(l -> l[1] == "EP", lines)
  AR = findfirst(l -> l[1] == "AR", lines)
  PY = findfirst(l -> l[1] == "PY", lines)
  DI = findfirst(l -> l[1] == "DI", lines)
  lines[AF:TI-1]
  authors = []
  push!(authors, lines[AF][2:end])
  for l in lines[AF+1:TI-1]
    push!(authors, l)
  end
  n_authors = length(authors)
  for (i, v) in enumerate(authors)
    author_name = ""
    end_last_name = findfirst(w -> w[end] == ',', v)
    for w in v[end_last_name+1:end]
      author_name *= w * " "
    end
    for w in v[1:end_last_name-1]
      author_name *= w * " "
    end
    author_name *= v[end_last_name][1:end-1]
    bib_str *= author_name
    if i < n_authors
      bib_str *= ", "
      if i == n_authors - 1
        bib_str *= "and "
      end
    end
  end
  bib_str *= ".\\\n"
  lit = lines[TI][2:end]
  for li = TI+1:SO-1
    lit = [lit; lines[li]]
  end
  for (i, w) in enumerate(lit)
    i > 1 && (bib_str *= " ")
    bib_str *= w
  end
  bib_str *= ".\n"
  bib_str *= "*"
  for (i, w) in enumerate(lines[SO][2:end])
    i > 1 && (bib_str *= " ")
    if w in ("AND", "OF", "IN", "THE")
      bib_str *= lowercase(w)
    elseif w in ("PLOS",)
      bib_str *= w
    else
      bib_str *= w[1] * lowercase(w[2:end])
    end
  end
  bib_str *= "*, "
  bib_str *= lines[VL][2]
  if BP !== nothing
    bib_str *= ":" * lines[BP][2] * "-" * lines[EP][2]
  elseif AR !== nothing
    bib_str *= ", Article number: " * lines[AR][2]
  end
  bib_str *= ", " * lines[PY][2] * ".\n"
  if DI !== nothing
    bib_str *= "[(DOI)](http://dx.doi.org/" * lines[DI][2] * ")\n"
  end
  print(bib_str)
end