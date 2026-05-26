using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    [Header("Canvases")]
    public GameObject mainMenuCanvas;
    
    private void Start()
    {
        mainMenuCanvas.SetActive(true);
    }

    public void NewGame()
    {
        if (File.Exists(Application.persistentDataPath + "/save" + ".json"))
            File.Delete(Application.persistentDataPath + "/save" + ".json");
        SceneManager.LoadScene("LD_V0.5");
    }
    
    public void LoadGame()
    {
        SceneManager.LoadScene("LD_V0.5");
    }

    public void QuitGame()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
}
