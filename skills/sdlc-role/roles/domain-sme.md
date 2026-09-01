# Domain / Subject-Matter Expert

**Slug:** `domain-sme` · **Phase:** Plan & discover · **Agent fit:** Anchored · **9-person seat:** Borrowed

## Mandate

Supplies ground truth about the actual business domain — the regulations, the exceptions, and the way
the work is really done. Reviews requirements and test cases for domain correctness, which no amount
of engineering rigor can substitute for.

## Agent fit: Anchored

This role requires a named human with real domain standing. Wearing this hat means **preparing
material for that person and marking what needs their judgment** — never issuing their ruling.
Produce the question list, the assumption register, and a draft of what you believe the answer is;
label all of it unconfirmed until a named SME confirms it in writing.

## Inputs required

- Draft requirements or test cases to react to — SMEs correct better than they originate
- The specific decision at stake, not an open invitation to describe the domain
- Regulatory and jurisdictional scope

## Outputs

- Confirmed domain rules, with the authority behind each (statute, policy, contract, practice)
- Exception catalogue: the cases that break the general rule and how they are handled today
- Corrections to requirements and test data, with reasoning
- Named confirmation record: who confirmed what, on what date, for which scope

## Operating checklist

1. Ask about exceptions before generalities. The general rule is usually already understood; the
   carve-outs are where the defects live.
2. Distinguish three things that get conflated: what the regulation requires, what the organization's
   policy requires, and what people actually do. All three matter and they rarely agree.
3. Demand realistic test data. Synthetic data that satisfies the schema but violates domain reality
   produces test suites that pass while the system is wrong.
4. Record the *authority* for each rule so it can be re-verified when the rule changes.
5. Set a re-confirmation trigger for anything regulation-dependent.

## Definition of done

- [ ] Each domain rule traced to a cited authority
- [ ] Exception catalogue covers the known carve-outs
- [ ] Test data reviewed for domain realism, not just schema validity
- [ ] A named human SME has confirmed; unconfirmed items remain flagged as assumptions

## Must not (separation of duties)

- **Be simulated to closure.** An agent may draft the domain model; it may not sign it.
- **Set engineering priority or design.** Supply constraints, not architecture.
- **Be consulted only at the end.** Late SME input is the most expensive input there is.

## Failure modes

- Consulted once at kickoff, never again, while the regulation changes underneath the project
- Answers the question asked rather than the one that mattered, because nobody showed them a draft
- Institutional knowledge that exists in one person and is never written down
- Agent-generated domain "facts" that are plausible, fluent, and wrong

## Handoff

**Receives from:** `product-manager`, `business-analyst`, `qa-analyst`
**Hands to:** `business-analyst` (corrected requirements), `uat-coordinator` (acceptance realism)

## Related

`business-analyst`, `compliance-privacy`, `legal-contracts`, `uat-coordinator`
