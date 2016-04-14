#!/usr/bin/python2
# -*- coding: UTF-8 -*-

import re
import sys

file_names = sys.argv[1:]

# tuo-exp-cq.defense.vex-vs-atk3.effect[].climbex.at-2015-11-01-12.log
FNAME_FORMAT = re.compile(
    r'^tuo-exp-cq'
    r'.(?P<ad>attack|defense)'
    r'.(?P<commander>\w+)-vs-(?P<enemy>[\w;]+)'
    r'.effect\[(?P<effect>(?:[^]])*)\]'
    r'.(?P<algo>\w+)'
    r'.at-(?P<at>\d{4}-\d{2}-\d{2}-\d{2}).log$'
)

# Optimized Deck: 6 units: 22.2: Typhon Vex, Soul Annex, Syndicate Goliath, ...
# Optimized Deck: 10 units: (0.0376712% stall) 99.3784: Daedalus, Dreamhaunter, ...
RECORD_FORMAT = re.compile(
    r'^(?P<fin>Optimized Deck: )?(?P<units>\d+) units:'
    r'(?: \$(?P<cost>\d+))?'
    r'(?: \((?P<stall>[0-9.]+)% stall\))?'
    r' (?P<win_rate>[0-9.]+):'
    r' (?P<deck>.*)$'
)

REFIND_FORMAT = re.compile(
    r'^Results refined: '
)

# Deck improved: KAhNWwVJ+VJ+eeAhZCDhHBEh: [123] A -> [456] B: 94.684 (191 123 41 / 200)'
ITERS_FORMAT = re.compile(
    r'^(Deck improved: .*: )?[0-9.]+ \((\d+ )+/ (?P<iters>\d+)\)$'
)


##
##  -s (sim) mode
##

# Dracorex Hivelord, Unirager, Tormentor, Tormentor, Overmind Bane, Sacrificial Chamber, Cimex Parasite, Vile Emergence, Vile Emergence, Vile Emergence, Riktox Liquefier
# win%: 82.4078 (1837 1880 ... / <iters>) 
# stall%: 0.0936906 (0 2 1 ... / <iters>)
# loss%: 17.4986 (163 118 ... / <iters>)

SIM_DECK_FORMAT = re.compile(
    '^(?P<deck>(?P<fin>[^,:#()]+(?:, [^,:]+)+))$'
)

SIM_WIN_RATE_FORMAT = re.compile(
    '^win%: (?P<win_rate>[0-9.]+) \((?:\d+ )+/ (?P<iters>\d+)\)$'
)

SIM_STALL_RATE_FORMAT = re.compile(
    '^stall%: (?P<stall>[0-9.]+) \((?:\d+ )+/ (?:\d+)\)$'
)


results = list()

for fname in file_names:
    m = FNAME_FORMAT.match(fname)
    if not m:
        raise Exception('bad file name (format violation): %s' % fname)
    fname_attrs = m.groupdict()
    result_attrs = {}
    with open(fname, 'r') as f:
        algo = fname_attrs['algo']
        if algo == 'sim':
            for x in f:
                for fmt in (SIM_DECK_FORMAT, SIM_WIN_RATE_FORMAT, SIM_STALL_RATE_FORMAT):
                    m = fmt.match(x)
                    if m:
                        if (fmt == SIM_DECK_FORMAT):
                            if result_attrs.has_key('deck'):
                                break
                            xcnt = x.count(',')
                            result_attrs['units'] = xcnt < 10 and "{}+".format(xcnt) or "10"
                        result_attrs.update(m.groupdict())
                        break
        elif algo in ('climbex', 'climb'):
            m_rec = None
            m_imp = None
            for x in f:
                if REFIND_FORMAT.match(x):
                    continue

                m = RECORD_FORMAT.match(x)
                if m:
                    m_rec = m
                    continue

                m = ITERS_FORMAT.match(x)
                if m:
                    m_imp = m
                    continue
            if None in (m_rec, m_imp):
                raise Exception('file not ready yet: %s' % fname)
            result_attrs.update(m_rec.groupdict())
            result_attrs.update(m_imp.groupdict())
        else:
            raise Exception("unsupported algo: {}".format(algo))
        win_rate = float(result_attrs['win_rate'])
        results.append((fname, fname_attrs, result_attrs, win_rate))

from_worts_to_best = sorted(results, key=lambda t: -t[3]) # sort by win_rate (index=4)

attack_effect_to_result_mapping = {}
defense_effect_to_result_mapping = {}

for x in from_worts_to_best:
    ad = x[1]['ad']
    enemy = x[1]['enemy']
    dst_mapping = None
    if ad == 'attack':
        dst_mapping = attack_effect_to_result_mapping
    elif ad == 'defense':
        dst_mapping = defense_effect_to_result_mapping
    else:
        raise ValueError(ad)
    effect = x[1]['effect']
    if not dst_mapping.has_key(effect):
        dst_mapping[effect] = {}
    if not dst_mapping[effect].has_key(enemy):
        dst_mapping[effect][enemy] = list()
    dst_mapping[effect][enemy].append(x)

def show_result(sorted_result, header):
    if not sorted_result:
        return
    print '\n\n ***  {}  ***\n'.format(header)
    for x in sorted_result:
        cost = 'cost' in x[2] and x[2]['cost'] or "-"*5
        print ' {proc_state} I{result_attrs[iters]:<3} {win_rate:5.1f}% $[ {cost:<5} ]'\
            '  <{result_attrs[units]:>2} unt> {result_attrs[deck]}'\
            .format(
                proc_state = x[2]['fin'] and 'FIN' or 'RUN',
                fname_attrs = x[1],
                result_attrs = x[2],
                win_rate = x[3],
                cost = cost,
            )

# show attack
for effect, m in attack_effect_to_result_mapping.items():
    for enemy, result in m.items():
        show_result(result, 'Attack on [ {} ] vs «{}»'.format(effect, enemy))

# show defense
for effect, m in defense_effect_to_result_mapping.items():
    for enemy, result in m.items():
        show_result(result, 'Defense on [ {} ] vs «{}»'.format(effect, enemy))
