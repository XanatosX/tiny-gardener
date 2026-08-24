class_name UpgradeBoughtUnlockCondition extends UnlockCondition

@export var item: Item

func is_unlocked(bridge: UnlockBridge) -> bool:
	return bridge.item_is_known(item)