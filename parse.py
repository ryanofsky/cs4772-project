#!/usr/bin/python

import os
import sys
import re
import stem

issues = { "domestic"    : ("Domestic Issues", "+"),
           "econ"        : ("Economy",         "o"),
           "edu"         : ("Education",       "*"),
           "environ"     : ("Environment",     "."),
           "foreign"     : ("Foreign Policy",  "x"),
           "health"      : ("Healthcare",      "s"),
           "immigration" : ("Immigration",     "d"),
           "social"      : ("Social Issues",   "^") }

candidates = { "clint"  : ("Clinton",  0),
               "ed"     : ("Edwards",  1),
               "giul"   : ("Giuliani", 2),
               "huck"   : ("Huckabee", 3),
               "mccain" : ("Mccain",   4),
               "obama"  : ("Obama",    5),
               "rom"    : ("Romney",   6),
               "thom"   : ("Thompson", 12) }

colors = [ (0.0,    0.0,    0.0),    #color 0  Black
           (0.0,    0.0,    2.0/3),  #color 1  Blue
           (0.0,    2.0/3,  0.0),    #color 2  Green
           (0.0,    2.0/3,  2.0/3),  #color 3  Cyan
           (2.0/3,  0.0,    0.0),    #color 4  Red
           (2.0/3,  0.0,    2.0/3),  #color 5  Magenta
           (2.0/3,  1.0/3,  0.0),    #color 6  Brown
           (2.0/3,  2.0/3,  2.0/3),  #color 7  White
           (1.0/3,  1.0/3,  1.0/3),  #color 8  Gray
           (1.0/3,  1.0/3,  1.0),    #color 9  Light Blue
           (1.0/3,  1.0,    1.0/3),  #color 10 Light Green
           (1.0/3,  1.0,    1.0),    #color 11 Light Cyan
           (1.0,    1.0/3,  1.0/3),  #color 12 Light Red
           (1.0,    1.0/3,  1.0),    #color 13 Light Magenta
           (1.0,    1.0,    1.0/3),  #color 14 Yellow
           (1.0,    1.0,    1.0) ]   #color 15 Bright White

def main(text_dir):
  issuewords = {}
  allwords = set()

  r = re.compile(r"[\s\r\n]+", re.M)
  stopwords = set(map(wstem, filter(None, r.split(open('stop_words').read()))))

  for file in os.listdir(text_dir):
    m = re.match(r"^([^-\d]+)-([^-\d]+)(\d*)$", file)
    if not m:
      print("skipping file `%s'" % file)
      continue
    issue, candidate, num = m.groups()
    try:
      words = issuewords[issue, candidate]
    except KeyError:
      words = issuewords[issue, candidate] = {}

    parse_file(text_dir, file, words, allwords, stopwords)

  w = list(allwords)
  w.sort()

  i = issuewords.keys()
  i.sort()

  print "Writing words.mat (%i word stems)" % len(allwords)
  fp = open("words.mat", "w")
  try:
    for issue, candidate in i:
      words = issuewords[issue, candidate]
      for word in w:
        fp.write("  %s" % words.get(word, 0))
      fp.write("\n")
  finally:
    fp.close()
  write_mat("markers.mat", [issues[e[0]][1] for e in i])
  write_mat("colors.mat", [colors[candidates[e[1]][1]] for e in i])

  # output stuff for legend
  issue_vals = issues.values()
  issue_vals.sort()
  candidate_vals = candidates.values()
  candidate_vals.sort()
  write_mat("legend_issue_names.mat", [v[0] for v in issue_vals])
  write_mat("legend_issue_markers.mat", [v[1] for v in issue_vals])
  write_mat("legend_candidate_names.mat", [v[0] for v in candidate_vals])
  write_mat("legend_candidate_colors.mat", [colors[v[1]] for v in candidate_vals])

def parse_file(text_dir, file, words, allwords, stopwords):
  fp = open(os.path.join(text_dir, file), "r")
  try:
    url = fp.readline().rstrip()
    if not re.match(r"^[a-z]+://\S+$", url):
      raise Exception("%s doesn't start with url" % file)

    print "Reading %s (%s)" % (file, url)
  
    for word in parse_words(fp.read(), stopwords):
      allwords.add(word)
      try:
        words[word]
      except KeyError:
        words[word] = 1
      else:
        words[word] += 1
    return words

  finally:
    fp.close()

def write_mat(file, mat):
  print "Writing", file
  l = max(map(len, mat))
  fp = open(file, "w")
  try:
    for row in mat:
      if isinstance(row, basestring):
        for c in row:
          fp.write("  %s" % ord(c))
        for c in range(l - len(row)):
          fp.write("  %s" % ord(" "))
      else:
        for e in row:
          fp.write("  %s" % e)
        for c in range(l - len(row)):
          fp.write("  0")
      fp.write("\n")
  finally:
    fp.close()

def parse_words(str, stopwords):
  for word in re.split(r"[^-\.'a-zA-Z]|\.\.\.", str):
    word = word.strip("-.'").lower()
    if word:
      word = wstem(word)
      if word not in stopwords:
        yield word

p = stem.PorterStemmer()
def wstem(w):
  return p.stem(w, 0, len(w)-1)
  
if __name__ == "__main__":
  if len(sys.argv) < 2:
     print "Usage: parse.py text_dir"
     sys.exit(1)
  main(sys.argv[1])
