using System;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

class PublishEditor
{
	#region MenuItems

	static protected string[] GetCurrentScene()
	{
		return new string[1] { EditorApplication.currentScene };
	}

	static protected string[] GetBuildScenes()
	{
		return Array.ConvertAll<EditorBuildSettingsScene, string>(EditorBuildSettings.scenes, new Converter<EditorBuildSettingsScene, string>(delegate(EditorBuildSettingsScene s) { return s.path; }));
	}

	[MenuItem("Tools/Publish/Build/Debug/Web")]
	static public void PublishBuildWebDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.Web, false); }
	[MenuItem("Tools/Publish/Build/Debug/Web Streamed")]
	static public void PublishBuildWebStreamDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.WebStreamed, false); }
	[MenuItem("Tools/Publish/Build/Debug/Flash")]
	static public void PublishBuildFlashDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.Flash, false); }
	[MenuItem("Tools/Publish/Build/Debug/NaCl")]
	static public void PublishBuildNaClDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.NaCl, false); }
	[MenuItem("Tools/Publish/Build/Debug/Standalone Windows")]
	static public void PublishBuildStandaloneWinDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.StandaloneWindows, false); }
	[MenuItem("Tools/Publish/Build/Debug/Standalone Mac")]
	static public void PublishBuildStandaloneMacDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.StandaloneMac, false); }
	[MenuItem("Tools/Publish/Build/Debug/Standalone Linux")]
	static public void PublishBuildStandaloneLinDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.StandaloneLinux, false); }
	[MenuItem("Tools/Publish/Build/Debug/Android Mobile")]
	static public void PublishBuildAndroidMobileDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.AndroidMobile, false); }
	[MenuItem("Tools/Publish/Build/Debug/Android Tab")]
	static public void PublishBuildAndroidTabDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.AndroidTab, false); }
	[MenuItem("Tools/Publish/Build/Debug/iOS Mobile")]
	static public void PublishBuildiOSMobileDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.iOSMobile, false); }
	[MenuItem("Tools/Publish/Build/Debug/iOS Tab")]
	static public void PublishBuildiOSTabDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.iOSTab, false); }

	[MenuItem("Tools/Publish/Build/Release/Web")]
	static public void PublishBuildWebRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.Web, false); }
	[MenuItem("Tools/Publish/Build/Release/Web Streamed")]
	static public void PublishBuildWebStreamRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.WebStreamed, false); }
	[MenuItem("Tools/Publish/Build/Release/Flash")]
	static public void PublishBuildFlashRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.Flash, false); }
	[MenuItem("Tools/Publish/Build/Release/NaCl")]
	static public void PublishBuildNaClRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.NaCl, false); }
	[MenuItem("Tools/Publish/Build/Release/Standalone Windows")]
	static public void PublishBuildStandaloneWinRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.StandaloneWindows, false); }
	[MenuItem("Tools/Publish/Build/Release/Standalone Mac")]
	static public void PublishBuildStandaloneMacRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.StandaloneMac, false); }
	[MenuItem("Tools/Publish/Build/Release/Standalone Linux")]
	static public void PublishBuildStandaloneLinRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.StandaloneLinux, false); }
	[MenuItem("Tools/Publish/Build/Release/Android Mobile")]
	static public void PublishBuildAndroidMobileRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.AndroidMobile, false); }
	[MenuItem("Tools/Publish/Build/Release/Android Tab")]
	static public void PublishBuildAndroidTabRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.AndroidTab, false); }
	[MenuItem("Tools/Publish/Build/Release/iOS Mobile")]
	static public void PublishBuildiOSMobileRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.iOSMobile, false); }
	[MenuItem("Tools/Publish/Build/Release/iOS Tab")]
	static public void PublishBuildiOSTabRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.iOSTab, false); }

	[MenuItem("Tools/Publish/Build + Run/Debug/Web")]
	static public void PublishBuildRunWebDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.Web, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/Web Streamed")]
	static public void PublishBuildRunWebStreamDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.WebStreamed, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/Flash")]
	static public void PublishBuildRunFlashDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.Flash, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/NaCl")]
	static public void PublishBuildRunNaClDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.NaCl, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/Standalone Windows")]
	static public void PublishBuildRunStandaloneWinDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.StandaloneWindows, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/Standalone Mac")]
	static public void PublishBuildRunStandaloneMacDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.StandaloneMac, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/Standalone Linux")]
	static public void PublishBuildRunStandaloneLinDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.StandaloneLinux, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/Android Mobile")]
	static public void PublishBuildRunAndroidMobileDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.AndroidMobile, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/Android Tab")]
	static public void PublishBuildRunAndroidTabDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.AndroidTab, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/iOS Mobile")]
	static public void PublishBuildRuniOSMobileDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.iOSMobile, true); }
	[MenuItem("Tools/Publish/Build + Run/Debug/iOS Tab")]
	static public void PublishBuildRuniOSTabDebug() { PublishScenes(GetBuildScenes(), PublishMode.Debug, PublishPlatform.iOSTab, true); }

	[MenuItem("Tools/Publish/Build + Run/Release/Web")]
	static public void PublishBuildRunWebRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.Web, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/Web Streamed")]
	static public void PublishBuildRunWebStreamRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.WebStreamed, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/Flash")]
	static public void PublishBuildRunFlashRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.Flash, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/NaCl")]
	static public void PublishBuildRunNaClRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.NaCl, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/Standalone Windows")]
	static public void PublishBuildRunStandaloneWinRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.StandaloneWindows, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/Standalone Mac")]
	static public void PublishBuildRunStandaloneMacRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.StandaloneMac, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/Standalone Linux")]
	static public void PublishBuildRunStandaloneLinRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.StandaloneLinux, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/Android Mobile")]
	static public void PublishBuildRunAndroidMobileRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.AndroidMobile, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/Android Tab")]
	static public void PublishBuildRunAndroidTabRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.AndroidTab, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/iOS Mobile")]
	static public void PublishBuildRuniOSMobileRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.iOSMobile, true); }
	[MenuItem("Tools/Publish/Build + Run/Release/iOS Tab")]
	static public void PublishBuildRuniOSTabRelease() { PublishScenes(GetBuildScenes(), PublishMode.Release, PublishPlatform.iOSTab, true); }

	#endregion

	static public void PublishScenes(string[] scenes, PublishMode mode, PublishPlatform platform, bool run)
	{
		string progressTitle = "Publishing "+ platform.ToString() +" "+ mode.ToString();

		int sceneCount = scenes.Length;
		int sceneIndex = 0;
		string[] sceneToBuild = new string[sceneCount];
		foreach (string scene in scenes)
		{
			++sceneIndex;
			EditorUtility.DisplayProgressBar(
				progressTitle,
				"(" + sceneIndex + " of " + sceneCount + ") " + "Saving " + scene,
				0
			);

			EditorApplication.isPaused = false;
			EditorApplication.isPlaying = false;

			string currentScene = scene;
			List<string> scenePath = new List<string>(currentScene.Split('/'));
			string sceneFile = scenePath[scenePath.Count - 1];
			scenePath.RemoveAt(scenePath.Count - 1);
			scenePath.Add("Builds");
			scenePath.Add(mode.ToString());
			scenePath.Add(platform.ToString());

			System.IO.Directory.CreateDirectory(string.Join("/", scenePath.ToArray()));

			scenePath.Add(sceneFile);
			string tempScene = string.Join("/", scenePath.ToArray());
			
			EditorApplication.SaveScene(currentScene);
			EditorApplication.SaveScene(tempScene);
			EditorApplication.OpenScene(tempScene);

			sceneToBuild[sceneIndex - 1] = tempScene;

			EditorUtility.DisplayProgressBar(
				progressTitle,
				"(" + sceneIndex + " of " + sceneCount + ") " + "Finding publishing scripts",
				0
			);

			int count = 0;
			Publish[] components = (Publish[])UnityEngine.Object.FindObjectsOfType(typeof(Publish));
			SortedDictionary<int, List<Publish>> publishing = new SortedDictionary<int, List<Publish>>();
			foreach (Publish publish in components)
			{
				int depth = 0;
				Transform p = publish.gameObject.transform;
				for (; p != null; p = p.parent, ++depth) ;
				if (!publishing.ContainsKey(depth)) publishing.Add(depth, new List<Publish>());
				publishing[depth].Add(publish);
				count++;
			}

			int current = 1;
			foreach (KeyValuePair<int, List<Publish>> pair in publishing.Reverse())
			{
				foreach (Publish publish in pair.Value)
				{
					if (publish == null || publish.gameObject == null)
						continue;

					Type type = publish.GetType();

					EditorUtility.DisplayProgressBar(
						progressTitle,
						"(" + sceneIndex + " of " + sceneCount + ") " + publish.gameObject.name + "." + type.ToString(),
						current / count
					);
				
					try
					{
						publish.PublishGameObject(mode, platform);
					}
					catch (Exception e) {
						Debug.LogError(publish.GetType().ToString() +".PublishGameObject() :"+ e.Message);
					}

					++current;
				}
			}

			EditorApplication.SaveScene(tempScene);
			EditorApplication.OpenScene(currentScene);
			//FileUtil.DeleteFileOrDirectory(tempScene);
		}
		AssetDatabase.Refresh();

		if (!run)
		{
			EditorUtility.ClearProgressBar();
			return;
		}

		EditorUtility.DisplayProgressBar(
			progressTitle,
			"Building & launching player",
			0
		);

		BuildTarget target = BuildTarget.WebPlayer;
		BuildOptions options = BuildOptions.None;
		string extension = "";

		switch (mode)
		{
			case PublishMode.Debug:
				options = BuildOptions.AutoRunPlayer | BuildOptions.WebPlayerOfflineDeployment | BuildOptions.Development | BuildOptions.AllowDebugging | BuildOptions.ConnectWithProfiler | BuildOptions.SymlinkLibraries;
				break;
			case PublishMode.Release:
				options = BuildOptions.AutoRunPlayer | BuildOptions.WebPlayerOfflineDeployment;
				break;
		}

		switch (platform)
		{
			case PublishPlatform.Web:
				target = BuildTarget.WebPlayer;
				break;
			case PublishPlatform.WebStreamed:
				target = BuildTarget.WebPlayerStreamed;
				break;
			case PublishPlatform.Flash:
				target = BuildTarget.FlashPlayer;
				break;
			case PublishPlatform.NaCl:
				target = BuildTarget.NaCl;
				break;
			case PublishPlatform.StandaloneWindows:
				target = BuildTarget.StandaloneWindows;
				extension = ".exe";
				break;
			case PublishPlatform.StandaloneMac:
				target = BuildTarget.StandaloneOSXUniversal;
				break;
			case PublishPlatform.StandaloneLinux:
				target = BuildTarget.StandaloneLinux;
				break;
			case PublishPlatform.AndroidMobile:
			case PublishPlatform.AndroidTab:
				target = BuildTarget.Android;
				extension = ".apk";
				break;
			case PublishPlatform.iOSMobile:
			case PublishPlatform.iOSTab:
				target = BuildTarget.iPhone;
				break;
		}

		BuildPipeline.BuildPlayer(sceneToBuild, "Builds" + "/" + mode.ToString() + "/" + platform.ToString() + extension, target, options);

		EditorUtility.ClearProgressBar();
	}
}
