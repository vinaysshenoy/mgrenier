using UnityEngine;
using System.Collections.Generic;

public class BitmapInputTextMesh : BitmapTextMesh
{
	protected bool hasFocus = false;
	protected int caret = 0;

	new public void Start()
	{
		base.Start();
		if (this.Text != null)
			this.caret = this.Text.Length;
	}

	public void OnGUI()
	{
		Event e = Event.current;

		if (e.isMouse && e.type == EventType.MouseUp)
		{
			Camera camera = Camera.main;
			Vector2 mouse = e.mousePosition;
			mouse.y = camera.pixelHeight - mouse.y;

			Vector3[] bounds = this.GetTextBounds();
			for (int a = 3; a >= 0; --a)
				bounds[a] = camera.WorldToScreenPoint(bounds[a]);

			this.hasFocus = mouse.x >= bounds[0].x && mouse.x <= bounds[2].x && mouse.y <= bounds[0].y && mouse.y >= bounds[2].y;

			e.Use();
		}

		if (this.hasFocus)
		{
			if (e.isKey && e.type == EventType.KeyDown)
			{
				if (e.keyCode == KeyCode.Escape)
					this.hasFocus = false;
				else if (e.keyCode == KeyCode.Backspace && this.Text.Length > 0)
					this.Text = this.Text.Substring(0, this.Text.Length - 1);
				else if (e.keyCode == KeyCode.None)
				{
					this.Text += Input.inputString;
				}
			}
			e.Use();
		}

	}
}
