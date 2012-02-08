using System;
using UnityEngine;

public abstract class Publish : MonoBehaviour
{
	public abstract void PublishGameObject(PublishMode mode, PublishPlatform platform);
}