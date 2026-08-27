class_name MultiDisplayRule extends UiDisplayRule

@export var rules: Array[UiDisplayRule] = []

func should_be_visible() -> bool:
	for rule: UiDisplayRule in rules:
		if not rule.should_be_visible():
			return false
	return true

func should_remove() -> bool:
	return rules.any(func(rule: UiDisplayRule) -> bool: return rule.should_remove())
	