import copy
import json
import collections
import argparse


def mrp2conllu(ud):
    lines = []
    for node in ud["nodes"]:
        if "anchors" in node and len(node["anchors"]) > 1:
            print("Multi-anchor in ud: {} \n (node: {})".format(ud, node["id"]))
        # id, token, lemma, upos, xpos, '_', head, label, '_', range
        #zho.mrp does not have anchors
        if "anchors" in node:
            line = [str(node["id"]), node["label"], node["values"][0], node["values"][1],
                    node["values"][2], '_', '_', '_', '_', 'TokenRange=' + str(node["anchors"][0]["from"])
                    + ':' + str(node["anchors"][0]["to"])]
        else:
            line = [str(node["id"]), node["label"], node["values"][0], node["values"][1],
                    node["values"][2], '_', '_', '_', '_']
        lines.append(line)

    # print (lines)
    if "edges" in ud:
        for edge in ud["edges"]:
            src = edge["source"]
            tgt = edge["target"]-1
            # print (src, tgt)
            if lines[tgt][6] is not '_':
                print("Multi-head in ud : {} \n (node: {})".format(ud, tgt))
                exit()
            lines[tgt][6] = str(src + 1)
            lines[tgt][7] = edge["label"]
    lines.insert(0, "#" + ud["id"])
    # print(lines)
    return lines



parser = argparse.ArgumentParser(description="Convert udpipe mrp to conllu");
parser.add_argument("input", type=str, help="udpipe mrp input file");
parser.add_argument("--outdir", type=str, help="output dir");
args = parser.parse_args();

if args.outdir is not None:
    file = args.outdir  + str(args.input).split("/")[-1].strip(".mrp") + '.conllu'
    with open(args.input, 'r') as fi_ud, open(file, 'wb') as fo:
        line_ud = fi_ud.readline().strip()
        while line_ud:
            ud = json.loads(line_ud, object_pairs_hook=collections.OrderedDict)
            conllu =  mrp2conllu(ud)
            line_ud = fi_ud.readline().strip()
            for i in conllu:
                item = "    ".join(i) if type(i) == list else i
                # item = item.replace("\"", "")
                fo.write((json.dumps(item) + '\n').replace("\"", "").encode())
            fo.write(("\n").encode())

print("Conversion finished.")



