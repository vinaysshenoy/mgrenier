using UnityEngine;

class PublishRemoveGameObjectMode : Publish
{
	public PublishMode remove = PublishMode.None;

	override public void PublishGameObject(PublishMode mode, PublishPlatform platform)
	{
		if (
			(this.remove == PublishMode.Debug && mode == PublishMode.Debug) ||
			(this.remove == PublishMode.Release && mode == PublishMode.Release)
		)
			DestroyImmediate(this.gameObject);
		else
			DestroyImmediate(this);
	}
}
