using UnityEngine;

class PublishRemoveGameObjectPlatform : Publish
{
	public PublishPlatform remove = PublishPlatform.None;

	override public void PublishGameObject(PublishMode mode, PublishPlatform platform)
	{
		if (
			(this.remove == PublishPlatform.Web && platform == PublishPlatform.Web) ||
			(this.remove == PublishPlatform.WebStreamed && platform == PublishPlatform.WebStreamed) ||
			(this.remove == PublishPlatform.Flash && platform == PublishPlatform.Flash) ||
			(this.remove == PublishPlatform.NaCl && platform == PublishPlatform.NaCl) ||
			(this.remove == PublishPlatform.StandaloneWindows && platform == PublishPlatform.StandaloneWindows) ||
			(this.remove == PublishPlatform.StandaloneMac && platform == PublishPlatform.StandaloneMac) ||
			(this.remove == PublishPlatform.StandaloneLinux && platform == PublishPlatform.StandaloneLinux) ||
			(this.remove == PublishPlatform.AndroidMobile && platform == PublishPlatform.AndroidMobile) ||
			(this.remove == PublishPlatform.AndroidTab && platform == PublishPlatform.AndroidTab) ||
			(this.remove == PublishPlatform.iOSMobile && platform == PublishPlatform.iOSMobile) ||
			(this.remove == PublishPlatform.iOSTab && platform == PublishPlatform.iOSTab)
		)
			DestroyImmediate(this.gameObject);
		else
			DestroyImmediate(this);
	}
}
