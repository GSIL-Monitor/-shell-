1��ADS����
1.1 ׼������,�ο������ݻ����������
a.װ��
���������Ļ�������װ�ò���ϵͳ��װ��ģ�塢��������Ϣ�����ԭ��ADS_cs�ڵ��װ������
  ��ӵ����

1.1.1���ر�����Ƿ�װ���汾�Ƿ���δ��װ����һ�£�

rpm -qa |egrep "apsara-dayu|chenxiang-agent|apsara-netqos|cgroup"

������ֱ����£�
apsara-dayu
apsara-dayu-watchdog
chenxiang-agent
apsara-netqos
libcgroup
cgroup.config

��汾�Բ��Ͽ�ʹ����������
pssh -h $ads_iplist -i 'yum -y remove ����'		###ж������
pssh -h $ads_iplist -i 'yum -y install ���� -b test'	###��װ����	


ȷ�ϼ�Ⱥ��δ��װ������java�汾���Աȸ�װ������java�汾��ȷ����ԭ��һ�¡�

ADSʹ�õ�java�汾���Ը�������İ汾Ϊ׼��һ��Ϊjdk 1.8
/opt/taobao/java/bin/java -version

��δװ,��¼ads���켯Ⱥ��apsara_ag,ִ����������,$ads_iplist��ʾд�����ݻ���ip���ļ�
prsync -h $ads_iplist /opt/aliyun/app/jdk/resources/ali-jdk-1.8.0_66-94.el5.x86_64.rpm /tmp
pssh -h $ads_iplist "rpm -q ali-jdk || sudo rpm -i /tmp/ali-jdk-1.8.0_66-94.el5.x86_64.rpm --force" 
�ڿ���֮ǰ���ȴ�ͨads_ag��apsara_ag�������������ͨ��
��ͨͨ��
����ͨag������������adminͨ����
  ��dms_ag����
  sudo su root
  scp $ads_ag_ip:/home/amin/.ssh/authorized_keys /tmp/     ##��ads_ag��˽Կ����dms_ag��
  chown admin:admin /tmp/authorized_keys
  pscp -h iplist -A /tmp/authorized_keys /home/amin/.ssh/authorized_keys		##��˽Կ���ǵ������ݵĻ�����


���������װ���������ݵĲ���������1.2�Ĳ���
1.2 �޸�Quota>
a.�鿴��ǰquotaֵ
	��¼ads_ag
  r quota 
  ������鿴��Ⱥquota״̬���õ�����ǰCPU��MEM ��quota CPU_Quota_Old/MEM_Quota_Old
  ���������¹��ο������õ�ֵΪInitQuoa��ֵ(static��ֵ)��ScaleRatio�ֶ�Ϊ��ǰʹ���˶���Quota��
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
|Account|Alias          |SchedulerType  |Strategy |InitQuota                |ScaledQuota        |ScaleRatio         |Runtime            |UsageInfo                |

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

|       |               |               |         |      |CPU:10000000      |                   |                   |                   |         |CPU:0          |

|       |               |               |         |Static|------------------|CPU:471200         |CPU:10000000       |CPU:0              |Used     |---------------|

|       |               |               |         |      |Mem:100000000     |                   |                   |                   |         |Mem:0          |

|1      |ifb            |Fifo           |Preempt  |-------------------------|-------------------|-------------------|-------------------|-------------------------|

|       |               |               |         |      |CPU:100           |                   |                   |                   |         |CPU:0          |

|       |               |               |         |Min   |------------------|Mem:17421086       |Mem:100000000      |Mem:12718080       |Available|---------------|

|       |               |               |         |      |Mem:500           |                   |                   |                   |         |Mem:0          |

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
b.�鿴��ǰ����ڵ����,Ҳ���Բο�R���е�cs�ڵ���
��search pangu_chunkserver |wc -l 
c.�����µ�cpu��mem quota������CPU_Quota/MEM_Quota��ֵ�ο�initQuota��staticֵ�����㷽�����£�
��CPU_Quota_New=(�����ݻ�����+��Ⱥ���м���ڵ����)/ ��Ⱥ���м���ڵ���� * 1.2 * CPU_Quota_Old
��MEM_Quota_New=(�����ݻ�����+��Ⱥ���м���ڵ����)/ ��Ⱥ���м���ڵ���� * 1.2 * MEM_Quota_Old
d.������quota
��r setquota -i ${Account} -a ${Alias} -s ${CPU_Quota_New} ${MEM_Quota_New}
��Account��AliasΪ��ͼ����Ӧ�ֶε�ֵ

1.3 ���������ɫ
��ӡtubo ip
�鿴ԭ��tubo�Ľ�ɫ
search tubo��>tubo_ip
for i in `cat tubo_ip`;do me -i $i;done

����������chunkserver�����ɫ
��apsara_ag��ִ�У�
/home/admin/dayu/install/role_resize --set_role="${role}" add /tmp/add.list
�鿴��ӡ����־��failedֵΪ�ա���ʾ��ɫ�����ɹ�

ע�⣺
  ˫������ ${role} �����ݣ�������ֳ��������м���ڵ�Ľ�ɫ���趨��
����ͨ�����me -i  ${odps_cs_ip}   �鿴���������м���ڵ�Ľ�ɫ��һ�����м���ڵ�Ľ�ɫ��һ����
���ٸ��ݵõ��Ľ�ɫ�����и�ʽ���±༭��ֻ�н�ɫ��������Role_ǰ׺��������Ⱥ���ƣ�����ɫ֮���ö��Ÿ�����
���磺
  ͨ��me����鵽�ĵ�ǰcs��ɫ��Ϣ���£�
    "role_ads_cs|role_deploy_agent|role_pangu_chunkserver|role_shennong_inspector|role_tubo|role_watch_dog|rol e_xihe_worker|clusterName_XXXX"
  ��ô,--set_role="${role}",�����е���������д����
    "ads_cs,deploy_agent,pangu_chunkserver,shennong_inspector,tubo,watch_dog,xihe_worker"
���£�
/home/admin/dayu/install/role_resize --set_role="N36.22,deploy_agent,pangu_chunkserver,shennong_inspector,tubo,watch_dog,xihe_worker" add /tmp/add.list

1.4 ��������
pssh -h /tmp/add.list -i "home/admin/dayu/bin/super-apsarad start"

1.5 ������״̬
pssh �Ch  /tmp/add.list -i "/home/admin/dayu/bin/apsarad status"
������״̬������������ɡ�

1.6 ȷ�������ݻ����̹�״̬ΪNORMAL
puadmin lscs |grep tcp

1.7 ȷ�������ݵĻ���,����Դ�ܿ���
r ttrl

1.8 ȷ�������ݵĻ����Ƿ���
r tbnl

1.8.1 �������ݵĻ���û�д��
���ݾɻ���r tbnl��ֵ�����ֵ�ɲο����л�����˳�����±�д��ð�����߱���˫���š�
vi label_n35
{
    "fuxiServiceLable":"N35.22",
    "gallardoRM":"gallardoRM",
    "mergeNode":"mergeNode",
    "updateNode":"updateNode"
    "localNode":"localNode"
}

1.8.2 ���»������
python /apsara/deploy/rpc_wrapper/set_tubo_node_label_new.py -r default -i /home/admin/$ip_file -n /home/admin/$label_file -u abc

1.8.3 ����»�������Ƿ�ɹ�
	r tbnl	

2. �����֤
 2.1 ��֤pangu_chunkserver���̰��
 �õ�pangu_chunkserver���̺�pid
 ps -ef |grep pangu 
 �鿴����Ƿ���ȷ,list: 2-6Ϊ��ȷ
 taskset -cp $pid 
 ������֤�����£�
 pssh -h /tmp/add.list -i 'taskset -cp `pidof /apsara/pangu_chunkserver/pangu_chunkserver`' 
 
 2.2 ��֤tubo���̰��
 �õ�tubo���̺�pid
 ps -ef |grep /apsara/tubo/tubo
 �鿴����Ƿ���ȷ,list: 7-55Ϊ��ȷ
 taskset -cp $pid
 ������֤�����£�
	pssh -h /tmp/add.list -i 'taskset -cp `pidof /apsara/tubo/tubo`' 
 
 2.3 ��֤������,����Ϊ����δ���
 me -l | grep CLUSTER_CGROUP_CPU_CONFIG | grep CPUSET 
 ������֤�����£�
	pssh -h /tmp/add.list -i 'me -l | grep CLUSTER_CGROUP_CPU_CONFIG | grep CPUSET'
 
 2.3 ����pangu_chunkserver,tubo��˲���ȷ
 	
 	pangu_chunkserver�ֶ����
  search pangu_chunkserver >/tmp/csips
  pssh -h /tmp/csips "ps auxf | grep /apsara/pangu_chunkserver/pangu_chunkserver | grep  -v grep  | awk '{print $2}'  | xargs -i  /bin/cgclassify -g cpuset:/apsara/pangu/chunkserver  --sticky {}" 
	
 	tubo�ֶ����
  /home/admin/dayu/bin/search tubo >/tmp/tuboips
  pssh  -h /tmp/tuboips "ps auxf | grep /apsara/tubo/tubo  | grep  -v grep  | awk '{print $2}'  | xargs -i  sudo /bin/cgclassify -g cpuset:/apsara/tubo ��sticky {}"
 	
 	
 2.4��֤���
	���pangu_chunkserver���
	taskset -cp $pid
	���tubo���
  taskset -cp $pid
  ����֤������ȷ,����ads��Ⱥ����޸�������
	
	
3.����R������CMDB��
3.1.����R��
	������������R���У���Ŀ����������
3.2.����armory
	������������һ��armory���ϴ���armory�����豸����Ϊonline״̬����ɺ����alimonitor�鿴���������״̬��
3.3.����CMDB
	3.3.1.���ýű���ӣ�ʾ��Ϊ���vip��Ϣ�����cs�������Ϣ��ȥcs������ֶ��滻��Ӧ�����ֶ�
	cmdbClient.py put /ram=vip '[{"name": "master-api", "values": {"nc_list":"[\"10.12.218.32\"]","lb_id": "ram-master.pcloud.ga","vip_ip":"--","vport": "ram-master.pcloud.ga","srcport":"--",}}]'
	3.3.2.��һ�ַ���������ԭcmdb�Ͻڵ����Ϣ�����б༭�����ϴ�����cmdb�С�
	
�������

��ע��
cs�ڵ���������ʧ�ܣ������й��Ͻڵ��������߲������ο����£�
ͬ1.3���������ɫ������ʱ�Ƴ���ɫ����Ȼ�˲���ֻ�������ݻ����ϲ�������ڵ���������ADS��Ʒ��ͬѧ�ṩ������ϸ�����߷�����
/home/admin/dayu/install/role_resize remove /tmp/add.list