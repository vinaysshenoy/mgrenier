using UnityEngine;
using System;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CameraRatio : MonoBehaviour {

	public int Width = 800;
	public int Height = 480;
	public TextAnchor Align = TextAnchor.MiddleCenter;

	public void UpdateCameraViewport()
	{
		Camera camera = this.GetComponent<Camera>();
		if (camera == null)
			return;

		float ratio = (float)this.Width / this.Height;
		int screenWidth = Screen.width;
		int screenHeight = Screen.height;
		int resultWidth = Mathf.CeilToInt(ratio * screenHeight);
		int resultHeight = Screen.height;
		if (resultWidth > Screen.width)
		{
			resultWidth = Screen.width;
			resultHeight = Mathf.CeilToInt((1 / ratio) * screenWidth);
		}

		float screenProportionW = (float)resultWidth / screenWidth;
		screenProportionW = Mathf.Ceil(screenProportionW * 100) / 100;
		float screenProportionH = (float)resultHeight / screenHeight;
		screenProportionH = Mathf.Ceil(screenProportionH * 100) / 100;

		Rect rect = new Rect(0, 0, screenProportionW == 1f ? 1 : screenProportionW, screenProportionH == 1f ? 1 : screenProportionH);

		if (this.Align == TextAnchor.LowerLeft || this.Align == TextAnchor.MiddleLeft || this.Align == TextAnchor.UpperLeft)
			rect.x = 0;
		if (this.Align == TextAnchor.LowerRight || this.Align == TextAnchor.MiddleRight || this.Align == TextAnchor.UpperRight)
			rect.x = screenProportionW == 1f ? 0 : (1f - screenProportionW);
		if (this.Align == TextAnchor.LowerCenter || this.Align == TextAnchor.MiddleCenter || this.Align == TextAnchor.UpperCenter)
			rect.x = screenProportionW == 1f ? 0 : (1f - screenProportionW) / 2;

		if (this.Align == TextAnchor.LowerCenter || this.Align == TextAnchor.LowerLeft || this.Align == TextAnchor.LowerRight)
			rect.y = 0;
		if (this.Align == TextAnchor.UpperCenter || this.Align == TextAnchor.UpperLeft || this.Align == TextAnchor.UpperRight)
			rect.y = screenProportionH == 1f ? 0 : (1f - screenProportionH);
		if (this.Align == TextAnchor.MiddleCenter || this.Align == TextAnchor.MiddleLeft || this.Align == TextAnchor.MiddleRight)
			rect.y = screenProportionH == 1f ? 0 : (1f - screenProportionH) / 2;

		camera.rect = rect;
	}

	private int checkIncrement = 1;
	private float nextCheck = 0;

	public void Update()
	{
		if (Application.isEditor)
		{
			this.UpdateCameraViewport();
			return;
		}

		if (this.checkIncrement == 0)
			return;
		if (Time.realtimeSinceStartup > this.nextCheck)
		{
			this.UpdateCameraViewport();

			this.checkIncrement += checkIncrement;
			this.nextCheck = Time.realtimeSinceStartup + checkIncrement;
		}
	}

	public void OnDrawGizmos()
	{
		Camera camera = this.GetComponent<Camera>();
		if (camera == null)
			return;

		float halfW = this.Width;
		float halfH = this.Height;
		float ratio = camera.orthographicSize / ((float)this.Height / 2);
		float near = camera.near;
		float far = camera.far;

		halfW *= ratio;
		halfH *= ratio;
		halfW *= 0.5f;
		halfH *= 0.5f;

		Vector3[] bounds = new Vector3[8]{
			new Vector3(-halfW, halfH, near),
			new Vector3(halfW, halfH, near),
			new Vector3(halfW, -halfH, near),
			new Vector3(-halfW, -halfH, near),

			new Vector3(-halfW, halfH, far),
			new Vector3(halfW, halfH, far),
			new Vector3(halfW, -halfH, far),
			new Vector3(-halfW, -halfH, far),
		};

		Gizmos.matrix = this.transform.localToWorldMatrix;
		Gizmos.color = new Color(1, 1, 1, 0.5f);
		Gizmos.DrawLine(bounds[0], bounds[1]);
		Gizmos.DrawLine(bounds[1], bounds[2]);
		Gizmos.DrawLine(bounds[2], bounds[3]);
		Gizmos.DrawLine(bounds[3], bounds[0]);

		Gizmos.DrawLine(bounds[4], bounds[5]);
		Gizmos.DrawLine(bounds[5], bounds[6]);
		Gizmos.DrawLine(bounds[6], bounds[7]);
		Gizmos.DrawLine(bounds[7], bounds[4]);

		Gizmos.DrawLine(bounds[0], bounds[4]);
		Gizmos.DrawLine(bounds[1], bounds[5]);
		Gizmos.DrawLine(bounds[2], bounds[6]);
		Gizmos.DrawLine(bounds[3], bounds[7]);
	}
}
