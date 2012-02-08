using System.Xml;
using System.IO;
using UnityEditor;
using UnityEngine;

class BitmapFontEditor
{
	static private int ScaleFactor = 8;
	static private DistanceField.TextureChannel Channel = DistanceField.TextureChannel.RED;

	[MenuItem("Tools/Import selected BitmapFont", validate=true)]
	static public bool ImportBitmapFontValidate()
	{
		foreach (Object o in Selection.GetFiltered(typeof(Object), SelectionMode.DeepAssets))
		{
			string path = AssetDatabase.GetAssetPath(o.GetInstanceID());
			if (path.ToLower().EndsWith(".fnt"))
				return true;
		}
		return false;
	}

	[MenuItem("Tools/Import selected BitmapFont")]
	static public void ImportBitmapFont()
	{
		foreach (Object o in Selection.GetFiltered(typeof(Object), SelectionMode.DeepAssets))
		{
			string path = AssetDatabase.GetAssetPath(o.GetInstanceID());
			if (!path.ToLower().EndsWith(".fnt"))
				continue;

			string prefabPath = path.Substring(0, path.LastIndexOf('.')) + "_Font";
			string filename = Path.GetFileNameWithoutExtension(prefabPath + ".prefab");

			Object prefab = AssetDatabase.LoadAssetAtPath(prefabPath + ".prefab", typeof(GameObject));
			if (prefab == null)
				prefab = EditorUtility.CreateEmptyPrefab(prefabPath + ".prefab");

			GameObject go;
			if (prefab as GameObject != null)
				go = (GameObject)EditorUtility.InstantiatePrefab(prefab);
			else
				go = new GameObject();
			go.name = filename;

			BitmapFont bitmapfont = go.GetComponent<BitmapFont>();
			if (bitmapfont == null)
				bitmapfont = go.AddComponent<BitmapFont>();

			ParseBitmapFont(path, bitmapfont);

			EditorUtility.ReplacePrefab(go, prefab);
			GameObject.DestroyImmediate(go);
		}
	}

	static protected void ParseBitmapFont(string file, BitmapFont bitmapfont)
	{
		XmlDocument fnt = new XmlDocument();
		fnt.Load(file);

		XmlNode node;

		// Import info
		node = fnt.SelectSingleNode("/font/info");
		bitmapfont.Size = AttrToFloat(node, "size");

		node = fnt.SelectSingleNode("/font/common");
		bitmapfont.LineHeight = AttrToFloat(node, "lineHeight");
		bitmapfont.Base = AttrToFloat(node, "base");
		bitmapfont.ScaleW = AttrToFloat(node, "scaleW");
		bitmapfont.ScaleH = AttrToFloat(node, "scaleH");


		// Import chars
		XmlNodeList list = fnt.SelectNodes("/font/chars/char");
		bitmapfont.Chars = new BitmapFont.Char[list.Count];
		int i = 0;
		foreach(XmlNode c in list)
		{
			bitmapfont.Chars[i] = new BitmapFont.Char();
			bitmapfont.Chars[i].Id = AttrToInt(c, "id");
			bitmapfont.Chars[i].Position = AttrToVector2(c, "x", "y");
			bitmapfont.Chars[i].Size = AttrToVector2(c, "width", "height");
			bitmapfont.Chars[i].Offset = AttrToVector2(c, "xoffset", "yoffset");
			bitmapfont.Chars[i].XAdvance = AttrToFloat(c, "xadvance");
			bitmapfont.Chars[i].Page = AttrToInt(c, "page");
			++i;
		}

		// Import kernings
		list = fnt.SelectNodes("/font/kernings/kerning");
		bitmapfont.Kernings = new BitmapFont.Kerning[list.Count];
		i = 0;
		foreach (XmlNode k in list)
		{
			bitmapfont.Kernings[i] = new BitmapFont.Kerning();
			bitmapfont.Kernings[i].FirstChar = AttrToInt(k, "first");
			bitmapfont.Kernings[i].SecondChar = AttrToInt(k, "second");
			bitmapfont.Kernings[i].Amount = AttrToInt(k, "amount");
			++i;
		}

		// Import pages & texture
		list = fnt.SelectNodes("/font/pages/page");
		Texture2D[] textures = new Texture2D[list.Count];
		Texture2D[] distances = new Texture2D[list.Count];
		i = 0;
		string path;
		Texture2D input;
		TextureImporter importer;
		foreach (XmlNode p in list)
		{
			path = Path.GetDirectoryName(file) + "/" + p.Attributes["file"].Value;
			input = (Texture2D)AssetDatabase.LoadAssetAtPath(path, typeof(Texture2D));

			importer = (TextureImporter)TextureImporter.GetAtPath(path);
			importer.isReadable = true;
			importer.textureType = TextureImporterType.Advanced;
			importer.maxTextureSize = 4096;
			importer.textureFormat = TextureImporterFormat.ARGB32;
			AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceSynchronousImport);

			distances[i] = DistanceField.CreateDistanceFieldTexture(input, Channel, input.width / ScaleFactor);
			textures[i] = ResizeTexture(input, input.width / ScaleFactor, input.height / ScaleFactor);
			++i;
		}


		// Build Distance atlas
		input = new Texture2D(0, 0);
		bitmapfont.PageOffsets = input.PackTextures(distances, 0);
		byte[] data = input.EncodeToPNG();
		path = file.Substring(0, file.LastIndexOf('.')) + "_Dist.png";
		File.WriteAllBytes(path, data);
		AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceSynchronousImport);

		Material mat = new Material(Shader.Find("Distance Map/Shadow"));
		mat.mainTexture = (Texture2D)AssetDatabase.LoadAssetAtPath(path, typeof(Texture2D));
		path = file.Substring(0, file.LastIndexOf('.')) + "_Vecto.mat";
		AssetDatabase.CreateAsset(mat, path);
		AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceSynchronousImport);

		// Build atlas
		input = new Texture2D(0, 0);
		bitmapfont.PageOffsets = input.PackTextures(textures, 0);
		data = input.EncodeToPNG();
		path = file.Substring(0, file.LastIndexOf('.')) + "_Diff.png";
		File.WriteAllBytes(path, data);
		AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceSynchronousImport);

		importer = (TextureImporter)TextureImporter.GetAtPath(path);
		importer.isReadable = true;
		importer.textureType = TextureImporterType.Advanced;
		importer.maxTextureSize = 4096;
		importer.textureFormat = TextureImporterFormat.ARGB32;
		importer.filterMode = FilterMode.Point;
		AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceSynchronousImport);

		mat = new Material(Shader.Find("Unlit/Transparent Tinted"));
		mat.mainTexture = (Texture2D)AssetDatabase.LoadAssetAtPath(path, typeof(Texture2D));
		path = file.Substring(0, file.LastIndexOf('.')) + "_Retro.mat";
		AssetDatabase.CreateAsset(mat, path);
		AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceSynchronousImport);

		// Import atlas
		path = file.Substring(0, file.LastIndexOf('.')) + "_Dist.png";
		importer = (TextureImporter)TextureImporter.GetAtPath(path);
		importer.isReadable = true;
		importer.textureType = TextureImporterType.Advanced;
		importer.textureFormat = TextureImporterFormat.Alpha8;
		AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceSynchronousImport);

		// Import atlas
		bitmapfont.PageAtlas = (Texture2D)AssetDatabase.LoadAssetAtPath(path, typeof(Texture2D));
	}

	static private int AttrToInt(XmlNode node, string attr)
	{
		return int.Parse(node.Attributes[attr].Value, System.Globalization.NumberFormatInfo.InvariantInfo);
	}

	static private float AttrToFloat(XmlNode node, string attr)
	{
		return float.Parse(node.Attributes[attr].Value, System.Globalization.NumberFormatInfo.InvariantInfo);
	}

	static private Vector2 AttrToVector2(XmlNode node, string x, string y)
	{
		return new Vector2(AttrToFloat(node, x), AttrToFloat(node, y));
	}

	static private Texture2D ResizeTexture(Texture2D source, int width, int height)
	{
		Texture2D result = new Texture2D(width, height, source.format, true);
		Color[] pixels = result.GetPixels(0);
		float rx = ((float)1 / source.width) * ((float)source.width / width);
		float ry = ((float)1 / source.height) * ((float)source.height / height);

		for (int a = 0, b = pixels.Length; a < b; ++a)
			pixels[a] = source.GetPixelBilinear(rx * ((float)a % width), ry * ((float)Mathf.Floor(a / width)));

		result.SetPixels(pixels);
		result.Apply();
		return result;
	}
}