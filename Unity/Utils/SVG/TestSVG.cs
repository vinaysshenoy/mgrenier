using System;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
class TestSVG : MonoBehaviour
{

	void Start()
	{
		MeshFilter mf = this.GetComponent<MeshFilter>();


		string path = Application.dataPath + "/Objects/rect.svg";

		Debug.Log(path);
		SVG.SVGReader svg = new SVG.SVGReader(path);

		mf.mesh = svg.SingleShape(1f);


	}

}
