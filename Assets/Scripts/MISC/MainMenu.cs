using System.Collections;
using System.Collections.Generic;
using System.IO;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public static class OptionsData
{
    public static bool isFxOn = true;
}
public class MainMenu : MonoBehaviour
{
    [Header("Canvases")]
    public GameObject mainMenuCanvas;

    public TextMeshProUGUI fx;

    private void Start()
    {
        mainMenuCanvas.SetActive(true);
        if  (OptionsData.isFxOn)
            fx.text = "Enabled";
        else
            fx.text = "Disabled";
    }

    public void NewGame()
    {
        if (File.Exists(Application.persistentDataPath + "/save" + ".json"))
            File.Delete(Application.persistentDataPath + "/save" + ".json");
        int currentSceneIndex = SceneManager.GetActiveScene().buildIndex;
        int nextSceneIndex = currentSceneIndex + 1;
        SceneManager.LoadScene(nextSceneIndex);
    }
    
    public void LoadGame()
    {
        if (File.Exists(Application.persistentDataPath + "/save" + ".json"))
        {
            int currentSceneIndex = SceneManager.GetActiveScene().buildIndex;
            int nextSceneIndex = currentSceneIndex + 1;
            SceneManager.LoadScene(nextSceneIndex);
        }
    }

    public void QuitGame()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
    
    public void ChangeFX()
    {
        OptionsData.isFxOn = !OptionsData.isFxOn;
        if  (OptionsData.isFxOn)
            fx.text = "Enabled";
        else
            fx.text = "Disabled";
    }
}
