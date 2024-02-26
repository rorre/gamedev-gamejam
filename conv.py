from dataclasses import dataclass
import dataclasses
import json
import math
from typing import Literal


@dataclass
class Object:
    col: int
    time: int
    type: Literal["slider", "note"]
    size: int
    end_time: int
    has_clap: bool


def find_by_col(objs: list[Object], col: int):
    for o in objs:
        if o.col == col:
            return o
    return None


def parse():
    with open("objects.txt", "r") as f:
        objects = f.readlines()

    game_obj: list[Object] = []
    for obj in objects:
        obj = obj.strip()
        x, _, time, type, hitsound, rest = obj.split(",")

        end_time = int(time)
        if type == "128":
            end_time = int(rest.split(":", 1)[0])

        o = Object(
            min(3, max(0, math.floor(int(x) * 4 / 512))),  # clamp 0-3
            int(time),
            "slider" if type == "128" else "note",
            -1,
            end_time,
            int(hitsound) & 8 == 8,
        )
        game_obj.append(o)
    return game_obj


def group_by_t(game_obj: list[Object]):
    grouped_by_t: list[list[Object]] = []
    current_group: list[Object] = [game_obj[0]]
    for gobj in sorted(game_obj[1:], key=lambda x: x.time):
        if abs(current_group[0].time - gobj.time) > 5:
            grouped_by_t.append(sorted(current_group, key=lambda x: x.col))
            current_group = [gobj]
            continue

        current_group.append(gobj)
    else:
        grouped_by_t.append(sorted(current_group, key=lambda x: x.col))

    return grouped_by_t


def move_claps_to_left(grouped_objects: list[list[Object]]):
    for line in grouped_objects:
        clap_at = -1
        for i in range(3, -2, -1):
            o = find_by_col(line, i)
            if not o:
                if clap_at == -1:
                    continue
                find_by_col(line, i + 1).has_clap = True  # type: ignore
                clap_at = -1
            else:
                if o.has_clap:
                    clap_at = i
                    o.has_clap = False

    return grouped_objects


def resize_objs(grouped_objects: list[list[Object]]):
    final_objs: list[Object] = []
    for line in grouped_objects:
        base = line[0]
        clapping = False
        size = 0
        for i in range(5):
            o = find_by_col(line, i)
            if o:
                if o.has_clap:
                    base = o
                    clapping = True
                    size = 1
                    continue

                if clapping:
                    size += 1
                else:
                    o.size = 1
                    final_objs.append(o)
            else:
                if not clapping:
                    continue

                final_objs.append(
                    Object(
                        col=base.col,
                        time=base.time,
                        type=base.type,
                        size=size,
                        end_time=base.end_time,
                        has_clap=base.has_clap,
                    )
                )
                clapping = False
                size = 0

    return final_objs


objs = parse()
grouped = group_by_t(objs)
moved = move_claps_to_left(grouped)
final = resize_objs(moved)
with open("master.json", "w") as f:
    json.dump({"objects": list(map(lambda x: dataclasses.astuple(x)[:-1], final))}, f)
