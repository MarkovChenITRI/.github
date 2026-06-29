# 真人使用回饋表

## Bug1 - Github Action Failed at unit-tests

```results
2s
Run python -m pytest
============================= test session starts ==============================
platform linux -- Python 3.11.15, pytest-9.1.1, pluggy-1.6.0
rootdir: /home/runner/work/ai-hub-webui/ai-hub-webui
collected 249 items

tests/test_agent_workspace_routes.py .....                               [  2%]
tests/test_api_error_contract.py .F.....                                 [  4%]
tests/test_auth_roles.py ..............                                  [ 10%]
tests/test_database_unavailable_routes.py ...                            [ 11%]
tests/test_deployment_type_vocabulary.py .........                       [ 15%]
tests/test_group_management.py .........                                 [ 18%]
tests/test_hardware_products.py ....................................     [ 33%]
tests/test_model_card_publish_routes.py ............................     [ 44%]
tests/test_model_card_publishing.py .................................... [ 59%]
..                                                                       [ 59%]
tests/test_model_card_schema_contract.py .......                         [ 62%]
tests/test_platform_contact_routes.py ......                             [ 65%]
tests/test_quality_gates.py ....                                         [ 66%]
tests/test_route_boundaries.py ............                              [ 71%]
tests/test_security_session.py ............                              [ 76%]
tests/test_solution_services.py ...........................              [ 87%]
tests/test_solution_template.py ................................         [100%]

=================================== FAILURES ===================================
_________ ApiErrorContractTest.test_api_abort_uses_json_error_envelope _________

self = <test_api_error_contract.ApiErrorContractTest testMethod=test_api_abort_uses_json_error_envelope>

    def test_api_abort_uses_json_error_envelope(self):
        app = Flask(__name__)
        app.secret_key = 'test'
        register_routes(app)
        client = app.test_client()
        with client.session_transaction() as active_session:
            active_session['username'] = 'alice'
            active_session['role'] = 'user'
    
        response = client.post('/api/admin/model-card-publish/pg_001/reviews', json={}, headers={'Origin': 'http://localhost'})
    
        self.assertEqual(403, response.status_code)
>       self.assertEqual('FORBIDDEN', response.get_json()['error']['code'])
E       AssertionError: 'FORBIDDEN' != 'PERMISSION_DENIED'
E       - FORBIDDEN
E       + PERMISSION_DENIED

tests/test_api_error_contract.py:25: AssertionError
=========================== short test summary info ============================
FAILED tests/test_api_error_contract.py::ApiErrorContractTest::test_api_abort_uses_json_error_envelope - AssertionError: 'FORBIDDEN' != 'PERMISSION_DENIED'
- FORBIDDEN
+ PERMISSION_DENIED
======================== 1 failed, 248 passed in 2.05s =========================
Error: Process completed with exit code 1.
```

## 建議 - 我的模型頁面的設計與其他頁面差異太大，導致過大的認知負擔

建議用類似我的裝置的那種頁面排版，當要新增模型時點選新增裝置，跳出一個視窗來填一些生成yaml的資訊(有必要時可以從資料庫資料來提供選項)，然後看能不能直接用template+custom yaml幫他的github帳號創建一個新的REPOSITORY，然後叫他們按步驟1.2.3拉下來開發。而不是原有的1設定部署環境+2上架模型小卡這種過期設計(千萬不要參考這頁原本的設計，這頁裡面的東西都是過期很久的)

## 問題 - Github Page中的平台維運中，沒有一個專屬於"模型憑證與授權"的分類

婆行憑證與授權這是一個分類，他底下應該要有各種文件敘述給平台維護者釐清現有架構與設計邏輯。但現在一頁都沒有
