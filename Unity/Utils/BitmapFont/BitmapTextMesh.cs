using UnityEngine;
using System.Collections.Generic;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshFilter))]
public class BitmapTextMesh : MonoBehaviour
{
	public BitmapFont Font;
	public string Text;
	public Vector2 FontScale = new Vector2(1f, 1f);
	public bool Wrap = false;
	public Vector2 WrapSize = new Vector2(5f, 1f);
	public TextAnchor Anchor = TextAnchor.UpperLeft;
	public TextOverflow Overflow = TextOverflow.Bottom;

	private string renderedText;
	private float renderedScaleX;
	private float renderedScaleY;
	private float renderedWidth;
	private float renderedHeight;
	private TextAnchor renderedAnchor;
	private TextOverflow renderedOverflow;
	private bool renderedWrap;

	private Vector3[] quadVertices = {
		new Vector3(0, 0),
		new Vector3(0, 1),
		new Vector3(1, 1),
		new Vector3(1, 0),
	};

	private Vector3[] quadUVs = {
		new Vector3(0, 0),
		new Vector3(0, 1),
		new Vector3(1, 1),
		new Vector3(1, 0),
	};

	private int[] quadTriangles = {
		0, 1, 2,
		2, 3, 0
	};

	private Mesh mesh;
	private MeshFilter meshFilter;

	public enum TextOverflow : byte
	{
		Top = 0,
		Bottom
	}

	public void Start()
	{
		this.meshFilter = this.GetComponent<MeshFilter>();
		if (this.meshFilter.sharedMesh == null)
			this.meshFilter.sharedMesh = new Mesh();
		this.mesh = this.meshFilter.sharedMesh;
	}

	protected void UpdateText()
	{
		Vector3 renderSize2 = new Vector2(this.FontScale.x, this.FontScale.y);
		float maxWidth = this.Wrap && this.WrapSize.x > 0 ? this.WrapSize.x : float.MaxValue;
		float maxHeight = this.Wrap && this.WrapSize.y > 0 ? this.WrapSize.y : float.MaxValue;

		string[] lines;
		Vector2 bounds = this.Font.GetTextRect(this.Text, renderSize2, maxWidth, out lines);

		if (bounds.y > maxHeight)
		{
			List<string> newLines = new List<string>();
			newLines.AddRange(lines);
			bool removeFirst = this.Overflow == TextOverflow.Top;
			int overflow = Mathf.CeilToInt((bounds.y / renderSize2.y) - (maxHeight / renderSize2.y));

			if (overflow >= newLines.Count)
				newLines.Clear();
			else
			{
				if (removeFirst)
					newLines.RemoveRange(0, overflow);
				else
					newLines.RemoveRange(newLines.Count - overflow, overflow);
			}
			this.Text = string.Join("", newLines.ToArray());
		}
	}

	public void Update()
	{
		if (this.Font == null || (this.Text == this.renderedText && this.WrapSize.x == this.renderedWidth && this.WrapSize.y == this.renderedHeight && this.Anchor == this.renderedAnchor && this.FontScale.x == this.renderedScaleX && this.FontScale.y == this.renderedScaleY && this.Overflow == this.renderedOverflow && this.Wrap == this.renderedWrap))
			return;

		this.UpdateText();

		Vector3 position = new Vector3(0, -this.FontScale.y, 0);
		Vector3 renderSize = this.FontScale;
		float maxWidth = this.Wrap && this.WrapSize.x > 0 ? this.WrapSize.x : float.MaxValue;
		string[] lines;
		Vector2 bounds = this.Font.GetTextRect(this.Text, new Vector2(renderSize.x, renderSize.y), maxWidth, out lines);
		Vector3 offset = new Vector3(0, 0, 0);
		if (this.Anchor == TextAnchor.MiddleCenter || this.Anchor == TextAnchor.MiddleLeft || this.Anchor == TextAnchor.MiddleRight)
			offset.y -= bounds.y / 2;
		if (this.Anchor == TextAnchor.LowerCenter || this.Anchor == TextAnchor.LowerLeft || this.Anchor == TextAnchor.LowerRight)
			offset.y -= bounds.y;

		if (this.Anchor == TextAnchor.UpperRight || this.Anchor == TextAnchor.MiddleRight || this.Anchor == TextAnchor.LowerRight)
			offset.x = bounds.x;
		if (this.Anchor == TextAnchor.UpperCenter || this.Anchor == TextAnchor.MiddleCenter || this.Anchor == TextAnchor.LowerCenter)
			offset.x = bounds.x / 2;


		List<int> tris = new List<int>();
		List<Vector3> vertices = new List<Vector3>();
		List<Vector2> uvs = new List<Vector2>();

		this.GenerateTextMesh(position - offset, this.Text, renderSize, maxWidth, ref tris, ref vertices, ref uvs);

		this.mesh.Clear();
		this.mesh.vertices = vertices.ToArray();
		this.mesh.uv = uvs.ToArray();
		this.mesh.subMeshCount = 1;
		this.mesh.SetTriangles(tris.ToArray(), 0);

		this.renderedText = this.Text;
		this.renderedScaleX = this.FontScale.x;
		this.renderedScaleY = this.FontScale.y;
		this.renderedWidth = this.WrapSize.x;
		this.renderedHeight = this.WrapSize.y;
		this.renderedAnchor = this.Anchor;
		this.renderedOverflow = this.Overflow;
		this.renderedWrap = this.Wrap;
	}

	public void OnDrawGizmosSelected()
	{
		if (this.Font == null)
			return;

		Vector3[] bounds = this.GetTextBounds();

		Gizmos.color = Color.white;
		Gizmos.DrawLine(bounds[0], bounds[1]);
		Gizmos.DrawLine(bounds[1], bounds[2]);
		Gizmos.DrawLine(bounds[2], bounds[3]);
		Gizmos.DrawLine(bounds[3], bounds[0]);
	}

	public Vector3[] GetTextBounds()
	{
		if (this.Font == null)
			return null;

		float maxWidth = this.Wrap && this.WrapSize.x > 0 ? this.WrapSize.x : float.MaxValue;
		float maxHeight = this.Wrap && this.WrapSize.y > 0 ? this.WrapSize.y : float.MaxValue;
		Vector3 position = new Vector3();
		Vector3 offset = new Vector3(0, 0, 0);
		string[] lines;
		Vector2 bounds = this.Font.GetTextRect(this.Text, this.FontScale, maxWidth, out lines);
		if (this.Wrap)
		{
			bounds.x = maxWidth;
			bounds.y = maxHeight;
		}

		if (this.Anchor == TextAnchor.MiddleCenter || this.Anchor == TextAnchor.MiddleLeft || this.Anchor == TextAnchor.MiddleRight)
			offset.y -= bounds.y / 2;
		if (this.Anchor == TextAnchor.LowerCenter || this.Anchor == TextAnchor.LowerLeft || this.Anchor == TextAnchor.LowerRight)
			offset.y -= bounds.y;
		if (this.Anchor == TextAnchor.UpperRight || this.Anchor == TextAnchor.MiddleRight || this.Anchor == TextAnchor.LowerRight)
			offset.x += bounds.x;
		if (this.Anchor == TextAnchor.UpperCenter || this.Anchor == TextAnchor.MiddleCenter || this.Anchor == TextAnchor.LowerCenter)
			offset.x += bounds.x / 2;

		//offset.y -= 1;
		position -= offset;

		Vector3[] textbounds = new Vector3[4];
		Matrix4x4 mat = this.transform.localToWorldMatrix;
		textbounds[0] = mat.MultiplyPoint(position);
		textbounds[1] = mat.MultiplyPoint(position + new Vector3(bounds.x, 0, 0));
		textbounds[2] = mat.MultiplyPoint(position + new Vector3(bounds.x, -bounds.y, 0));
		textbounds[3] = mat.MultiplyPoint(position + new Vector3(0, -bounds.y));

		return textbounds;
	}

	protected void GenerateTextMesh(Vector3 position, string text, Vector3 renderSize, float maxSize, ref List<int> tris, ref List<Vector3> vertices, ref List<Vector2> uvs)
	{
		Vector3 pos = new Vector3(position.x, position.y, position.z);
		Vector3 scale = renderSize / this.Font.Size;

		for (int a = 0, b = text.Length; a < b; ++a)
		{
			BitmapFont.Char c = this.Font.GetChar(text[a]);
			int vertIndex = vertices.Count;

			float k = 0;
			if (a < b - 1)
				k = this.Font.GetKerning(c.Id, (int)text[a + 1]);
			float l = (c.XAdvance + k) * scale.x;

			if ((int)text[a] == 10)
			{
				pos.x = position.x;
				pos.y -= renderSize.y;
				continue;
			}

			if ((pos.x - position.x) + l >= maxSize)
			{
				pos.x = position.x;
				pos.y -= renderSize.y;
			}

			Rect uv = this.Font.GetRect(c);
			Vector2 uvScale = new Vector2(uv.width, uv.height);
			Vector2 uvOffset = new Vector2(uv.x, uv.y);
			for (int d = 0, e = this.quadUVs.Length; d < e; ++d)
				uvs.Add(Vector2.Scale(this.quadUVs[d], uvScale) + uvOffset);

			Vector3 vertSize = Vector3.Scale(c.Size, scale);
			Vector3 vertOffset = Vector2.Scale(c.Offset, scale);
			vertOffset.y = renderSize.y - (vertOffset.y + vertSize.y); // top to bottom
			for (int d = 0, e = this.quadVertices.Length; d < e; ++d)
				vertices.Add(Vector3.Scale(this.quadVertices[d], vertSize) + pos + vertOffset);

			for (int d = 0, e = this.quadTriangles.Length; d < e; ++d)
				tris.Add(this.quadTriangles[d] + vertIndex);

			pos.x += l;
		}
	}
}
