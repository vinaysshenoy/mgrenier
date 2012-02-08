using UnityEngine;
using System;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshFilter))]
public class Console : BitmapTextMesh {

	static public object locker = new object();
	static protected Console instance;

	static public void Log(object message)
	{
		//lock (Console.locker)
		//{
			if (Console.instance == null)
				return;
			Console.instance.Text += message.ToString() + '\n';
		//}
	}

	public void SetupConsole()
	{
		if (Console.instance != null)
			return;

		Console.instance = this;
		this.Text = "";
	}

	new public void Start ()
	{
		base.Start();

		if (!Application.isEditor)
			this.SetupConsole();
	}

	new public void Update()
	{
		base.Update();

		if (Application.isEditor)
			this.SetupConsole();
	}
}
